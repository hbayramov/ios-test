//
//  BaseViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseSetup()
    }
}

extension BaseViewController {
    
    fileprivate func baseSetup() {
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .alabaster
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // setup activity indicator
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
    }

    func createStackView(for views: [UIView]? = nil, in axis: NSLayoutConstraint.Axis, spacing s: CGFloat) -> UIStackView {
        var stackView = UIStackView()
        if let v = views {
            stackView = UIStackView(arrangedSubviews: v)
        }
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = s
        stackView.axis = axis
        
        switch axis {
        case .vertical:
            stackView.distribution = .fill
        case .horizontal:
            stackView.distribution = .fillEqually
        @unknown default:
            print("axis not determined")
        }
        
        stackView.alignment = .fill
        return stackView
    }
    
    func setupPickerView(for pickerView: UIPickerView? = nil,
                         forDatePicker datePickerView: UIDatePicker? = nil,
                         textField tf: UITextField, barButton button: UIBarButtonItem) {
        if let view = pickerView {
            view.showsSelectionIndicator = true
            view.delegate = self
            view.dataSource = self
            tf.inputView = view
        }
        
        if let view = datePickerView {
            view.datePickerMode = .date
            view.locale = Locale.init(identifier: "AZ")
            tf.inputView = view
            tf.placeholder = view.date.toString()
        }
    
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .blue
        toolBar.sizeToFit()
        
        let doneButton = button
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tf.inputAccessoryView = toolBar
    }
    
}

extension BaseViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 0
    }
}
