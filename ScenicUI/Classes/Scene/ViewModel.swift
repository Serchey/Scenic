
import Combine

public protocol ViewModel: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype ViewEvent
    associatedtype ViewState
    
    func trigger(_ event: ViewEvent)
    var state: ViewState { get }
}

public extension ViewModel where ViewEvent == Void {
    func trigger(_ event: ViewEvent) {}
}

public extension ViewModel where ViewEvent == Never {
    func trigger(_ event: ViewEvent) {}
}

public extension ViewModel where ViewState == Void {
    var state: ViewState { Void() }
}
