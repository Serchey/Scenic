
public protocol SceneBindableViewController {
    associatedtype ViewModel
    
    func bindViewModel(viewModel: ViewModel)
}

public protocol ScenePresentableViewModel {
    func viewModelDidBind()
    func viewModelWillPresent()
    func viewModelDidPresent()
	func viewModelWillRemove()
}

public extension ScenePresentableViewModel {
    func viewModelDidBind() {}
    func viewModelWillPresent() {}
    func viewModelDidPresent() {}
	func viewModelWillRemove() {}
}

public final class SceneMVVM<ViewModel: ScenePresentableViewModel, ViewController: UIViewController & SceneBindableViewController>: Scene where ViewController.ViewModel == ViewModel {
    public var embeddedScenes:[Scene] {
        let allScenes: [Scene?] = topScenes + stackScenes + [bottomScene] + [leftScene] + [rightScene]
        return allScenes.compactMap { $0 }
    }
    
    private let model: ViewModel
    private let _viewController: ViewController
    
    private var topScenes: [Scene] = []
    private var stackScenes: [Scene] = []
    private var bottomScene: Scene?
    private var leftScene: Scene?
    private var rightScene: Scene?
    
    public var viewController: UIViewController {
        return _viewController
    }
    
    public init(model: ViewModel, viewController: ViewController) {
        self.model = model
        self._viewController = viewController
        
        if var model = model as? CurrentSceneAware {
            model.currentScene = self
        }
        
        sceneAssembleBeforePresenting()
    }
    
    private func sceneAssembleBeforePresenting() {
        _viewController.loadViewIfNeeded()
        _viewController.bindViewModel(viewModel: model)
        model.viewModelDidBind()
    }
    
    public func sceneWillPresent() {
        model.viewModelWillPresent()
        embeddedScenes.forEach { $0.sceneWillPresent() }
    }
    
    public func sceneDidPresent() {
        model.viewModelDidPresent()
        embeddedScenes.forEach { $0.sceneDidPresent() }
    }
	
	public func sceneWillRemove() {
		model.viewModelWillRemove()
		embeddedScenes.forEach { $0.sceneWillRemove() }
	}
    
    public func embed(scene: Scene, at position: EmbeddedScenePosition) {
        guard let viewController = _viewController as? SceneContainableViewController else {
            fatalError("The scene does not support embedding")
        }
        
        _viewController.loadViewIfNeeded()
        
        viewController.embed(viewController: scene.viewController, at: position)
        
        switch position {
        case .top:
            topScenes.append(scene)
        case .bottom:
            assert(bottomScene == nil)
            bottomScene = scene
        case .stack:
            stackScenes.append(scene)
        case .left:
            assert(leftScene == nil)
            leftScene = scene
        case .right:
            assert(rightScene == nil)
            rightScene = scene
        }
    }
    
    public func embedAtStack(scenes: [Scene]) {
        guard let viewController = _viewController as? SceneContainableViewController else {
            fatalError("The scene does not support embedding")
        }
        
        _viewController.loadViewIfNeeded()
        
        viewController.embedAtStack(viewControllers: scenes.map { $0.viewController })
        stackScenes = scenes
    }
}
