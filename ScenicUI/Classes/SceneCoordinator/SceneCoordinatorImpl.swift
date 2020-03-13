import RxSwift
import RxCocoa

public final class SceneCoordinatorImpl {
    private let window: UIWindow
    private var scenes = [Scene]()
    private var dbag = DisposeBag()
    
    public init(window: UIWindow) {
        self.window = window
    }
}

extension SceneCoordinatorImpl {
    private var currentScene: Scene? {
        return scenes.last
    }
    
    private var currentViewController: UIViewController? {
        return currentScene?.viewController
    }
}

extension SceneCoordinatorImpl: SceneCoordinator {
    private func belongs(viewController: UIViewController?, to scene: Scene?) -> Bool {
        guard let viewController = viewController, let scene = scene else {
            return false
        }
        
        if viewController === scene.viewController {
            return true
        }
        
        return scene.embeddedScenes.first { self.belongs(viewController: viewController, to: $0) } != nil
    }
    
    private func subscribeToNavigationControllerIfNeeded(for scene: Scene) {
        // used to automatically detect pressing "Back" button at the navigation bar
        if let navigationViewController = scene.viewController as? UINavigationController {
            navigationViewController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:willShow:animated:)))
                .subscribe(onNext: { [unowned self] args in
                    let isPresenting = self.belongs(viewController: args[1] as? UIViewController, to: self.currentScene)
                    if !isPresenting {
                        let scene = self.scenes.removeLast()
						scene.sceneWillRemove()
                    }
                })
                .disposed(by: dbag)
        }
    }
    
    public func present(_ scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        
        subscribeToNavigationControllerIfNeeded(for: scene)
        
        switch type {
        case .root:
            scene.sceneWillPresent()
            window.rootViewController = scene.viewController
            window.makeKeyAndVisible()
            scenes = [scene]
            scene.sceneDidPresent()
            subject.onCompleted()
        case .push, .replace:
            guard let navigationController = currentViewController?.navigationController ?? currentViewController as? UINavigationController else {
                fatalError("Can't push a view controller without the current navigation controller")
            }
            
            if scene.viewController is UINavigationController {
                fatalError("Pushing a navigation controller is not supported")
            }
            
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .take(1)
                .map { _ -> Void in
                    scene.sceneDidPresent()
                }
                .bind(to: subject)
            
            scene.sceneWillPresent()
            if type == .push {
                scenes.append(scene)
                navigationController.pushViewController(scene.viewController, animated: true)
            } else {
                scenes.removeLast()
                scenes.append(scene)
                let viewControllers = Array(navigationController.viewControllers.dropLast()) + [scene.viewController]
                navigationController.setViewControllers(viewControllers, animated: true)
            }
            
        case .modal:
            let presentingViewController = currentViewController
            scenes.append(scene)
            scene.sceneWillPresent()
            presentingViewController?.present(scene.viewController, animated: true) {
                scene.sceneDidPresent()
                subject.onCompleted()
            }
        }
        
        return subject
            .asObservable()
            .take(1)
            .ignoreElements()
    }
    
    public func dismiss(_ scene: Scene, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        
        switch type {
        case .root:
            fatalError("Unable to dismiss the root controller")
        case .replace:
            fatalError("Unable to dismiss replaced view controller, use .push instead")
        case .push:
            guard let navigationController = currentViewController?.navigationController else {
                fatalError("Can't pop a view controller without the current navigation controller")
            }

			scene.sceneWillRemove()

            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .take(1)
                .map { _ in }
                .bind(to: subject)
            
            navigationController.popViewController(animated: true)
        case .modal:
			scene.sceneWillRemove()

			scene.viewController.presentingViewController?.dismiss(animated: true) {
                subject.onCompleted()
            }
            guard let sceneIndex = scenes.firstIndex(where: { $0.viewController === scene.viewController }) else {
                fatalError("Attempt to dismiss a scene that is not in the tree")
            }
            scenes.removeLast(scenes.count - sceneIndex)
        }
        
        return subject
            .asObservable()
            .take(1)
            .ignoreElements()
    }
    
    public func popCurrentScene() -> Completable {
        return dismiss(currentScene!, type: .push)
    }
}
