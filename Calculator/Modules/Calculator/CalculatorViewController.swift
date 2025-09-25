import UIKit

class CalculatorViewController: UIViewController, CalculatorViewProtocol {
    var presenter: CalculatorPresenterProtocol?

    private let displayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 80, weight: .light)
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        presenter?.viewDidLoad()
    }

    func updateDisplay(with value: String) {
        displayLabel.text = value
    }

    private func setupUI() {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 10

        mainStackView.addArrangedSubview(displayLabel)

        let buttonRows: [[String]] = [
            ["AC", "+/-", "%", "÷"],
            ["7", "8", "9", "×"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "+"]
        ]

        for row in buttonRows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 10

            for title in row {
                let button = createButton(title: title)
                rowStackView.addArrangedSubview(button)
            }
            mainStackView.addArrangedSubview(rowStackView)
        }

        // Special layout for the last row
        let lastRowStackView = UIStackView()
        lastRowStackView.axis = .horizontal
        lastRowStackView.distribution = .fillEqually
        lastRowStackView.spacing = 10

        let zeroButton = createButton(title: "0")

        let rightButtonsStackView = UIStackView()
        rightButtonsStackView.axis = .horizontal
        rightButtonsStackView.distribution = .fillEqually
        rightButtonsStackView.spacing = 10

        let decimalButton = createButton(title: ".")
        let equalsButton = createButton(title: "=")

        rightButtonsStackView.addArrangedSubview(decimalButton)
        rightButtonsStackView.addArrangedSubview(equalsButton)

        lastRowStackView.addArrangedSubview(zeroButton)
        lastRowStackView.addArrangedSubview(rightButtonsStackView)

        mainStackView.addArrangedSubview(lastRowStackView)

        view.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            displayLabel.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        button.layer.cornerRadius = 40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true

        switch title {
        case "0"..."9", ".":
            button.backgroundColor = UIColor(white: 0.2, alpha: 1)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        case "÷", "×", "-", "+", "=":
            button.backgroundColor = .orange
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(operatorButtonTapped(_:)), for: .touchUpInside)
        case "AC":
             button.backgroundColor = .lightGray
             button.setTitleColor(.black, for: .normal)
             button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        default: // For "+/-" and "%"
            button.backgroundColor = .lightGray
            button.setTitleColor(.black, for: .normal)
            button.addTarget(self, action: #selector(specialOperatorTapped(_:)), for: .touchUpInside)
        }

        return button
    }

    @objc private func numberButtonTapped(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else { return }
        presenter?.numberButtonTapped(number)
    }

    @objc private func operatorButtonTapped(_ sender: UIButton) {
        guard let op = sender.title(for: .normal) else { return }
        if op == "=" {
            presenter?.equalsButtonTapped()
        } else {
            presenter?.operatorButtonTapped(op)
        }
    }

    @objc private func clearButtonTapped() {
        presenter?.clearButtonTapped()
    }

    @objc private func specialOperatorTapped(_ sender: UIButton) {
        guard let op = sender.title(for: .normal) else { return }
        presenter?.specialOperatorTapped(op)
    }
}