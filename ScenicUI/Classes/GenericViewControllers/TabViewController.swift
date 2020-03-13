
open class TabViewController<T>: UITabBarController, SceneBindableViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - SceneBindableViewController
    
    open func bindViewModel(viewModel: T) {
    }
}

extension TabViewController: SceneContainableViewController {
    public func embedAtStack(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
