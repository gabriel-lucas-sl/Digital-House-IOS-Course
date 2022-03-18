//
//  ViewController.swift
//  Calculadora
//
//  Created by Gabriel Lucas Alves da Silva on 15/03/22.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    let calculator = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ",", "="]
    ]
    
    var lastValue: Double?
    var nextValue: Double?
    var clearZero = true
    var math = ""

    
    // MARK: - Properties
    
    private let spacerView: UIView = {
        let view = UIView()
        let screenHeight = UIScreen.main.bounds.height
        view.anchor(height: screenHeight * 0.1)
        return view
    }()
    
    private let numberTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 80, weight: .light)
        tf.textColor = .white
        tf.autocapitalizationType = .none
        tf.keyboardAppearance = .dark
        tf.attributedPlaceholder = NSAttributedString(string: "0",
                                                      attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return tf
    }()
    
    private lazy var buttonsContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        
        let buttons = buildButtons()
        let stack = UIStackView()
        var arrOfStack: [UIStackView] = []
        for (index, line) in buttons.enumerated() {
            let stack = UIStackView()
            stack.distribution = .fillEqually
            stack.spacing = 10
            
            for (column, elem) in line.enumerated() {
                stack.addArrangedSubview(elem)
            }
            
            arrOfStack.append(stack)
        }
        
        
        for (index, elem) in arrOfStack.enumerated() {
            if index == 0 {
                view.addSubview(elem)
                elem.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 5,
                            paddingLeft: 16,
                            paddingRight: 16)
            } else {
                let lastStack = arrOfStack[index - 1]
                view.addSubview(elem)
                elem.anchor(top: lastStack.bottomAnchor,
                            left: view.leftAnchor,
                            right: view.rightAnchor,
                            paddingTop: 10,
                            paddingLeft: 16,
                            paddingRight: 16)
            }
        }
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func selectButton(_ sender: UIButton) {
        let currentValue = sender.currentTitle!
        
        if let _ = Double(currentValue) {
            if clearZero {
                numberTextField.placeholder! = ""
                clearZero = false
            }
            numberTextField.placeholder! += currentValue
            
            if math == "" {
                lastValue = Double(numberTextField.placeholder!)
            }
        }
        
        if math != "" {
            print("TEMOS UMA CONTA PARA REALIZAR", math)
            // se eu tenho lastValue armazenados
            // e o meu currentValue é um número
            // armazena nextValue
            
            if let _ = lastValue {
                if let currentNumber = Double(currentValue) {
                    nextValue = currentNumber
                }
            }
        }
        
        switch currentValue {
        case "AC":
            numberTextField.placeholder! = "0"
            lastValue = 0
            clearZero = true
        case "+/-":
            if let value = lastValue {
                numberTextField.placeholder! = String(describing: -value)
                lastValue = -value
                clearZero = true
            }
        case "%":
            if let value = lastValue {
                let count = value / 100
                numberTextField.placeholder! = String(describing: count)
                lastValue = value
                clearZero = true
            }
        case "÷":
            math = "÷"
            clearZero = true
        case "x":
            math = "x"
            clearZero = true
        case "-":
            math = "-"
            clearZero = true
        case "+":
            math = "+"
            clearZero = true
        case "=":
            // se meu math == "="
            // faz a conta do meu last math
            if math != "" {
                switch math {
                case "÷":
                    let count = lastValue! / nextValue!
                    numberTextField.placeholder! = String(describing: count)
                    math = ""
                case "x":
                    let count = lastValue! * nextValue!
                    numberTextField.placeholder! = String(describing: count)
                    math = ""
                case "-":
                    let count = lastValue! - nextValue!
                    numberTextField.placeholder! = String(describing: count)
                    math = ""
                case "+":
                    let count = lastValue! + nextValue!
                    numberTextField.placeholder! = String(describing: count)
                    math = ""
                default:
                    print()
                }
            }
        case ",":
            // TODO: Implement
            break
        default:
            print()
        }
    }
    
    // MARK: - Helpers
    
    func buildButtons() -> Array<Array<CircleButton>> {
        var btn = [[CircleButton]]()
        
        var buttons: [CircleButton] = []
        for (i, line) in calculator.enumerated() {
            for (j, elem) in line.enumerated() {
                if (i == 0 && j != 3) {
                    let btn = CircleButton()
                    btn.configureButtonUI(btnBackgroundColor: .gray36, placeholder: elem, foregroundColor: .white)
                    btn.setTitle(elem, for: .normal)
                    btn.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
                    buttons.append(btn)
                }
                
                if (i > 0 && j != 3) {
                    let btn = CircleButton()
                    btn.configureButtonUI(btnBackgroundColor: .gray58, placeholder: elem, foregroundColor: .white)
                    btn.setTitle(elem, for: .normal)
                    btn.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
                    buttons.append(btn)
                }
                
                if j == 3 {
                    let btn = CircleButton()
                    btn.configureButtonUI(btnBackgroundColor: .orange, placeholder: elem, foregroundColor: .white)
                    btn.setTitle(elem, for: .normal)
                    btn.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
                    buttons.append(btn)
                }
            }
            
            btn.append(buttons)
            buttons = []
        }
        
        return btn
    }
    
    func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(spacerView)
        spacerView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        view.addSubview(numberTextField)
        numberTextField.anchor(top: spacerView.bottomAnchor,
                               left: view.leftAnchor,
                               right: view.rightAnchor,
                               paddingLeft: 16,
                               paddingRight: 16)
     
        view.addSubview(buttonsContainer)
        buttonsContainer.anchor(top: numberTextField.bottomAnchor,
                                left: view.leftAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingTop: 20,
                                paddingBottom: 16)
    }
}

