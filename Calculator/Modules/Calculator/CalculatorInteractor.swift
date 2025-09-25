import Foundation

enum CalculationError: Error {
    case divisionByZero
    case invalidOperation
}

class CalculatorInteractor: CalculatorInteractorInputProtocol {
    weak var presenter: CalculatorInteractorOutputProtocol?

    func performCalculation(firstOperand: Double, secondOperand: Double, operation: String) {
        let result: Double
        do {
            switch operation {
            case "+":
                result = firstOperand + secondOperand
            case "-":
                result = firstOperand - secondOperand
            case "×":
                result = firstOperand * secondOperand
            case "÷":
                if secondOperand == 0 {
                    throw CalculationError.divisionByZero
                }
                result = firstOperand / secondOperand
            default:
                throw CalculationError.invalidOperation
            }
            presenter?.calculationDidFinish(with: result)
        } catch {
            presenter?.calculationDidFail(with: error)
        }
    }

    func performNegation(for number: Double) {
        presenter?.negationDidFinish(with: -number)
    }

    func performPercentage(for number: Double) {
        presenter?.percentageDidFinish(with: number / 100)
    }

    func clear() {
        presenter?.didClear(with: "0")
    }
}