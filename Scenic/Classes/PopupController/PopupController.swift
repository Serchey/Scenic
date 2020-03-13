import RxSwift

public protocol PopupController {
    func confirmPopup(title: String) -> Single<Bool>
}
