//
//  CircleButton.swift
//  Calculadora
//
//  Created by Gabriel Lucas Alves da Silva on 15/03/22.
//

import UIKit

class CircleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        anchor(height: 75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtonUI(btnBackgroundColor: UIColor, placeholder: String, foregroundColor: UIColor) {
        backgroundColor = btnBackgroundColor
        layer.cornerRadius = 35
        let attributedTitle = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30, weight: .regular), NSAttributedString.Key.foregroundColor : foregroundColor])
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
