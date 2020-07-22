//
//  ReceiptViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ReceiptViewController: BaseViewController {
    private let receipt: Receipt!
    
    private var bgView: UIView!
    private var dateLabel: UILabel!
    private var amount: UILabel!
    private var currency: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(with receipt: Receipt) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onHome() {
        if let window = UIApplication.shared.keyWindow {
            window.rootViewController = UINavigationController(rootViewController: CategoryViewController())
            window.makeKeyAndVisible()
        }
    }
}

//MARK: SetupViews
extension ReceiptViewController {
    
    fileprivate func setup() {
        setupNavigationController()
        setupMainView()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Receipt"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(onHome))
    }
    
    private func setupMainView() {
        bgView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .alabaster
            view.layer.cornerRadius = 5
            return view
        }()
        view.addSubview(bgView)
        
        dateLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = receipt.date?.UTCToLocal()
            label.textColor = .gray
            return label
        }()
        bgView.addSubview(dateLabel)
        
        let amountLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Amount"
            label.textColor = .gray
            return label
        }()
        bgView.addSubview(amountLabel)
        
        amount = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = receipt.amount?.value
            label.textColor = UIColor.gray.withAlphaComponent(0.5)
            return label
        }()
        bgView.addSubview(amount)
        
        let currencyLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Currency"
            label.textColor = .gray
            return label
        }()
        bgView.addSubview(currencyLabel)
        
        currency = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = receipt.amount?.currency
            label.textColor = UIColor.gray.withAlphaComponent(0.5)
            return label
        }()
        bgView.addSubview(currency)
        
        let fontSize: CGFloat = 14
    
        
        // setup constraints
        let safeArea = view.safeAreaLayoutGuide
        
        bgView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        bgView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.85).isActive = true
        bgView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        bgView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16).isActive = true
        
        var lastDetailLabel = dateLabel
        for detail in receipt?.details ?? [] {
            let label = createCustomLabel(withText: detail.k, size: fontSize, isValue: false)
            let value = createCustomLabel(withText: detail.v, size: fontSize, isValue: true)
            
            bgView.addSubview(label)
            bgView.addSubview(value)
            
            label.leadingAnchor.constraint(equalTo: lastDetailLabel!.leadingAnchor).isActive = true
            label.topAnchor.constraint(equalTo: lastDetailLabel!.bottomAnchor, constant: 16).isActive = true
            
            value.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
            value.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16).isActive = true
            
            lastDetailLabel = label
        }
        
        amountLabel.leadingAnchor.constraint(equalTo: lastDetailLabel!.leadingAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: lastDetailLabel!.bottomAnchor, constant: 16).isActive = true
        
        amount.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor).isActive = true
        amount.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16).isActive = true
        
        currencyLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor).isActive = true
        currencyLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16).isActive = true
        
        currency.centerYAnchor.constraint(equalTo: currencyLabel.centerYAnchor).isActive = true
        currency.trailingAnchor.constraint(equalTo: amount.trailingAnchor).isActive = true
    }
    
    private func createCustomLabel(withText text: String?, size s: CGFloat, isValue flag: Bool) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        if flag {
            label.textColor = UIColor.gray.withAlphaComponent(0.5)
        } else {
            label.textColor = .gray
            label.textAlignment = .right
        }
        
        return label
    }
}
