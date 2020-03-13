
open class HStackViewController<T>: UIViewController, SceneBindableViewController {
    @IBOutlet private var leftContainerView: UIView!
    @IBOutlet private var stackContainerView: UIStackView!
    @IBOutlet private var rightContainerView: UIView!
    
    @IBOutlet private var leftContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var rightContainerWidthConstraint: NSLayoutConstraint!
    
    private var stackViewControllers: [UIViewController] = []
    
    override open var nibBundle: Bundle? {
        return Bundle(for: HStackViewController.self)
    }
    
    open override var nibName: String? {
        return "HStackViewController"
    }
    
    // MARK: - SceneBindableViewController
    
    open func bindViewModel(viewModel: T) {
    }
}

extension HStackViewController: SceneContainableViewController {
    public func embed(viewController: UIViewController, at position: EmbeddedScenePosition) {
        addChild(viewController)
        
        switch position {
        case .top:
            assertionFailure("Not supported")
        case .bottom:
            assertionFailure("Not supported")
        case .stack:
            stackViewControllers.append(viewController)
            stackContainerView.addArrangedSubview(viewController.view)
        case .left:
            leftContainerView.fill(with: viewController.view)
        case .right:
            rightContainerView.fill(with: viewController.view)
        }
        viewController.didMove(toParent: self)
    }
    
    public func embedAtStack(viewControllers: [UIViewController]) {
        stackViewControllers.forEach { $0.removeFromParent() }
        stackViewControllers = []
        stackContainerView.removeSubviews()
        
        viewControllers.forEach { viewController in
            addChild(viewController)
            stackContainerView.addArrangedSubview(viewController.view)
            viewController.didMove(toParent: self)
            stackViewControllers.append(viewController)
        }
    }
}
