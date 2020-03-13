
public final class HudImpl: Hud {
    public lazy var mainWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.white
        return window
    }()
    
    public init() {}
}
