
public final class SceneMVC: Scene {
    public var embeddedScenes:[Scene] {
        let allScenes: [Scene?] = topScenes + stackScenes + [bottomScene] + [leftScene] + [rightScene]
        return allScenes.compactMap { $0 }
    }

    private var topScenes: [Scene] = []
    private var stackScenes: [Scene] = []
    private var bottomScene: Scene?
    private var leftScene: Scene?
    private var rightScene: Scene?

    public let viewController: UIViewController
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
        
        viewController.loadViewIfNeeded()
    }
    
    public func sceneWillPresent() {
        embeddedScenes.forEach { $0.sceneWillPresent() }
    }
    
    public func sceneDidPresent() {
        embeddedScenes.forEach { $0.sceneDidPresent() }
    }
	
	public func sceneWillRemove() {
		embeddedScenes.forEach { $0.sceneWillRemove() }
	}
    
    public func embed(scene: Scene, at position: EmbeddedScenePosition) {
        guard let viewController = viewController as? SceneContainableViewController else {
            fatalError("The scene does not support embedding")
        }
        
        self.viewController.loadViewIfNeeded()
        
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
        guard let viewController = viewController as? SceneContainableViewController else {
            fatalError("The scene does not support embedding")
        }
        
        self.viewController.loadViewIfNeeded()
        
        viewController.embedAtStack(viewControllers: scenes.map { $0.viewController })
        stackScenes = scenes
    }
}
