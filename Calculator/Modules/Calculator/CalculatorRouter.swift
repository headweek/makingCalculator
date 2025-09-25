import UIKit

class CalculatorRouter: CalculatorRouterProtocol {
    static func createModule() -> CalculatorViewController {
        let view = CalculatorViewController()
        let presenter: CalculatorPresenterProtocol & CalculatorInteractorOutputProtocol = CalculatorPresenter()
        let interactor: CalculatorInteractorInputProtocol = CalculatorInteractor()
        let router: CalculatorRouterProtocol = CalculatorRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter

        return view
    }
}