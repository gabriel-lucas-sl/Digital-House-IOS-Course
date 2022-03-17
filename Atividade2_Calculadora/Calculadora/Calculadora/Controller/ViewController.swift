//
//  ViewController.swift
//  Calculadora
//
//  Created by Gabriel Lucas Alves da Silva on 15/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    let calculator = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ",", "="]
    ]
    var clearZero = true
    var operation = ""
    var lastValue = ""
    
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
        let title = sender.currentTitle!
        let currentInput = numberTextField.placeholder!
        
        if let titleAsNumber = Int(title) {
            if clearZero {
                numberTextField.placeholder! = ""
                clearZero = false
            }
            numberTextField.placeholder! += String(titleAsNumber)
        } else {
            switch title {
            case "AC":
                numberTextField.placeholder! = "0"
                clearZero = true
            case "+/-":
                print("NAO SEI")
            case "%":
                if let number = Double(currentInput) {
                    let count = number/100
                    numberTextField.placeholder! = String(count)
                } else {
                    print("It's not a number")
                }
            case "÷":
                print("DIVISAO")
            case "x":
                print("MULTIPLICACAO")
            case "-":
                print("SUB")
            case "+":
                print("PLUS")
            case "=":
                print("EQUAL")
                clearZero = true
                numberTextField.placeholder! = ""
            default:
                print(title)
            }
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

