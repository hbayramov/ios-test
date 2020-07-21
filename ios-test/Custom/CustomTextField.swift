//
//  CustomTextField.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var label: String? {
        didSet {
            if let label = label {
                setupLabel(withText: label)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    convenience init(placeholder text: String) {
        self.init(frame: .zero)
        self.placeholder = text
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .alabaster
        textColor = .black
        clearButtonMode = .whileEditing
        layer.cornerRadius = 3
    }
    
    private func setupLabel(withText text: String) {
        let textFieldLabel: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = text
            lbl.textColor = .gray
            return lbl
        }()
        addSubview(textFieldLabel)
        
        textFieldLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textFieldLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let _ = leftView {
            return bounds.insetBy(dx: 40, dy: 7)
        }
        return bounds.insetBy(dx: 10, dy: 7)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

