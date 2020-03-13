import RxSwift

final public class PopupControllerImpl {
    private let sceneCoordinator: SceneCoordinator
    
    public init(sceneCoordinator: SceneCoordinator) {
        self.sceneCoordinator = sceneCoordinator
    }
}

extension PopupControllerImpl: PopupController {
    public func confirmPopup(title: String) -> Single<Bool> {
        return .create { [weak self] observer in
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            let alertScene = SceneMVC(viewController: alertController)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default) { [unowned alertScene] _ in
                self?.sceneCoordinator.dismiss(alertScene, type: .modal)
                observer(.success(true))
            })
            alertController.addAction(UIAlertAction(title: "No", style: .cancel) { [unowned alertScene] _ in
                self?.sceneCoordinator.dismiss(alertScene, type: .modal)
                observer(.success(false))
            })
        
            self?.sceneCoordinator.present(alertScene, type: .modal)
            
            return Disposables.create()
        }
    }
}
