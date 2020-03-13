
open class StackViewController<T>: UIViewController, SceneBindableViewController {
    @IBOutlet private var topContainerView: UIStackView!
    @IBOutlet private var stackContainerView: UIStackView!
    @IBOutlet private var bottomContainerView: UIView!
    
    @IBOutlet private var stackContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomContainerHeightConstraint: NSLayoutConstraint!
    
    private var stackViewControllers: [UIViewController] = []

    override open var nibBundle: Bundle? {
        return Bundle(for: StackViewController.self)
    }
    
    open override var nibName: String? {
        return "StackViewController"
    }

    // MARK: - SceneBindableViewController

    open func bindViewModel(viewModel: T) {
    }
}

extension StackViewController: SceneContainableViewController {
    public func embed(viewController: UIViewController, at position: EmbeddedScenePosition) {
        addChild(viewController)

        switch position {
        case .top:
            topContainerView.addArrangedSubview(viewController.view)
        case .bottom:
            bottomContainerView.fill(with: viewController.view)
        case .stack:
            stackViewControllers.append(viewController)
            stackContainerView.addArrangedSubview(viewController.view)
        case .left:
            assertionFailure("Not supported")
        case .right:
            assertionFailure("Not supported")
        }
        viewController.didMove(toParent: self)
        
        updateBottomContainerConstraints()
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
        
        updateBottomContainerConstraints()
    }
}

extension StackViewController {
    private func updateBottomContainerConstraints() {
        let hasControllersInStack = !stackContainerView.subviews.isEmpty
        stackContainerHeightConstraint.isActive = !hasControllersInStack
        bottomContainerHeightConstraint.isActive = hasControllersInStack
    }
}
