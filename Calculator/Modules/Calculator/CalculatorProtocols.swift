import Foundation

// MARK: - View
protocol CalculatorViewProtocol: AnyObject {
    var presenter: CalculatorPresenterProtocol? { get set }

    func updateDisplay(with value: String)
}

// MARK: - Interactor
protocol CalculatorInteractorInputProtocol: AnyObject {
    var presenter: CalculatorInteractorOutputProtocol? { get set }

    func performCalculation(firstOperand: Double, secondOperand: Double, operation: String)
    func performNegation(for number: Double)
    func performPercentage(for number: Double)
    func clear()
}

protocol CalculatorInteractorOutputProtocol: AnyObject {
    func calculationDidFinish(with result: Double)
    func negationDidFinish(with result: Double)
    func percentageDidFinish(with result: Double)
    func calculationDidFail(with error: Error)
    func didClear(with initialValue: String)
}

// MARK: - Presenter
protocol CalculatorPresenterProtocol: AnyObject {
    var view: CalculatorViewProtocol? { get set }
    var interactor: CalculatorInteractorInputProtocol? { get set }
    var router: CalculatorRouterProtocol? { get set }

    func viewDidLoad()
    func numberButtonTapped(_ number: String)
    func operatorButtonTapped(_ operator: String)
    func specialOperatorTapped(_ operator: String)
    func equalsButtonTapped()
    func clearButtonTapped()
}

// MARK: - Router
protocol CalculatorRouterProtocol: AnyObject {
    static func createModule() -> CalculatorViewController
}