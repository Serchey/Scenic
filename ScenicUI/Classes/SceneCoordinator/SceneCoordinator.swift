import RxSwift

public enum SceneTransitionType {
    case root
    case push
    case replace
    case modal
}

public protocol SceneCoordinator {
    @discardableResult
    func present(_ scene: Scene, type: SceneTransitionType) -> Completable
    
    @discardableResult
    func dismiss(_ scene: Scene, type: SceneTransitionType) -> Completable
    
    @discardableResult
    func popCurrentScene() -> Completable
}
