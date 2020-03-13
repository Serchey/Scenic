
public protocol Scene: class {
    var viewController: UIViewController { get }
    var embeddedScenes: [Scene] { get }
    
    func sceneWillPresent()
    func sceneDidPresent()
	func sceneWillRemove()

    func embed(scene: Scene, at position: EmbeddedScenePosition)
    func embedAtStack(scenes: [Scene])
}

public enum EmbeddedScenePosition {
    case top
    case stack
    case bottom
    case left
    case right
}

public protocol CurrentSceneAware {
    var currentScene: Scene! { get set }
}

public protocol SceneContainableViewController {
    func embed(viewController: UIViewController, at position: EmbeddedScenePosition)
    func embedAtStack(viewControllers: [UIViewController])
}

public extension SceneContainableViewController where Self: UIViewController {
    func embed(viewController: UIViewController, at position: EmbeddedScenePosition) { fatalError("Attempt to embed while viewController doesn't support embedding") }
    func embedAtStack(viewControllers: [UIViewController]) { fatalError("Attempt to embed while viewController doesn't support embedding") }
}
