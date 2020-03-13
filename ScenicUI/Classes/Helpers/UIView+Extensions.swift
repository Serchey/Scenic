
public extension UIView {
    func removeSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    func fill(with view: UIView) {
        guard self != view else { fatalError("Attempt to insert view inside itself") }
        
        removeSubviews()
        
        addSubview(view)
        view.constrainToAllSides(of: self)
    }
    
    func constrainToAllSides(of view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let top = topAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([leading, trailing, bottom, top])
    }
}
