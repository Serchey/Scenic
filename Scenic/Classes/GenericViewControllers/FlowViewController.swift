
open class FlowViewController<T>: UINavigationController {
}

extension FlowViewController: SceneBindableViewController {
    public func bindViewModel(viewModel: T) {
    }
}
