
public final class StaticViewModel<ViewEvent, ViewState>: ViewModel, Identifiable {
    public let state: ViewState

    public init(state: ViewState) {
        self.state = state
    }

    public func trigger(_ event: ViewEvent) {}
}

public extension StaticViewModel where ViewState == Void {
    convenience init() {
        self.init(state: ())
    }
}
