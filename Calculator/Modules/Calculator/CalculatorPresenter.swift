import Foundation

class CalculatorPresenter: CalculatorPresenterProtocol, CalculatorInteractorOutputProtocol {
    weak var view: CalculatorViewProtocol?
    var interactor: CalculatorInteractorInputProtocol?
    var router: CalculatorRouterProtocol?

    private var currentNumber: String = "0"
    private var firstOperand: Double?
    private var operation: String?
    private var isEnteringNumber: Bool = true

    func viewDidLoad() {
        view?.updateDisplay(with: currentNumber)
    }

    func numberButtonTapped(_ number: String) {
        if !isEnteringNumber {
            currentNumber = "0"
            isEnteringNumber = true
        }

        if number == "." && currentNumber.contains(".") {
            return // Avoid multiple decimal points
        }

        if currentNumber == "0" && number != "." {
            currentNumber = number
        } else {
            currentNumber += number
        }

        view?.updateDisplay(with: currentNumber)
    }

    func operatorButtonTapped(_ op: String) {
        if isEnteringNumber, let operand = firstOperand, let currentOp = operation {
            if let secondNumber = Double(currentNumber) {
                interactor?.performCalculation(firstOperand: operand, secondOperand: secondNumber, operation: currentOp)
            }
        } else {
            firstOperand = Double(currentNumber)
        }

        isEnteringNumber = false
        operation = op
    }

    func specialOperatorTapped(_ op: String) {
        guard let number = Double(currentNumber) else { return }

        switch op {
        case "+/-":
            interactor?.performNegation(for: number)
        case "%":
            interactor?.performPercentage(for: number)
        default:
            break
        }
    }

    func equalsButtonTapped() {
        guard let firstOperand = firstOperand,
              let operation = operation,
              let secondOperand = Double(currentNumber),
              isEnteringNumber else {
            return
        }

        interactor?.performCalculation(firstOperand: firstOperand, secondOperand: secondOperand, operation: operation)
        self.operation = nil
    }

    func clearButtonTapped() {
        interactor?.clear()
    }

    // MARK: - Interactor Output

    func calculationDidFinish(with result: Double) {
        updateDisplayWithResult(result)
        firstOperand = result
        isEnteringNumber = false
    }

    func negationDidFinish(with result: Double) {
        updateDisplayWithResult(result)
    }

    func percentageDidFinish(with result: Double) {
        updateDisplayWithResult(result)
    }

    func calculationDidFail(with error: Error) {
        currentNumber = "Error"
        view?.updateDisplay(with: currentNumber)
        isEnteringNumber = false
        firstOperand = nil
        operation = nil
    }

    func didClear(with initialValue: String) {
        currentNumber = initialValue
        firstOperand = nil
        operation = nil
        isEnteringNumber = true
        view?.updateDisplay(with: currentNumber)
    }

    private func updateDisplayWithResult(_ result: Double) {
        if floor(result) == result {
             currentNumber = String(Int(result))
        } else {
             currentNumber = String(result)
        }
        view?.updateDisplay(with: currentNumber)
    }
}