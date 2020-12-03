
import SwiftUI

public final class SceneUI<VM: ViewModel, V: ViewModelView>: Scene {
    private let model: VM
    private let view: V
    
    public init(model: VM, view: V) {
        self.model = model
        self.view = view

        presentableViewModel?.viewModelDidBind()
    }
    
    private lazy var _viewController = UIHostingController(rootView: view)

    private var presentableViewModel: ScenePresentableViewModel? {
        model as? ScenePresentableViewModel
    }
    
    public var viewController: UIViewController {
        _viewController
    }
    
    public var embeddedScenes: [Scene] = []
    
    public func sceneWillPresent() {
        presentableViewModel?.viewModelWillPresent()
    }
    
    public func sceneDidPresent() {
        presentableViewModel?.viewModelDidPresent()
    }
    
    public func sceneWillRemove() {
        presentableViewModel?.viewModelWillRemove()
    }
    
    public func embed(scene: Scene, at position: EmbeddedScenePosition) {
        fatalError("not implemented yet")
    }
    
    public func embedAtStack(scenes: [Scene]) {
        fatalError("not implemented yet")
    }
}
