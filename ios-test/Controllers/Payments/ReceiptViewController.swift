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
    
    init(with receipt: Receipt) {
        self.receipt = receipt
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup Views
extension ReceiptViewController {
    private func setup() {
        setupNavigationController()
        setupView()
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Receipt"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(onHome))
    }
    
    private func setupView() {
        
    }
}

//MARK: Class Methods
extension ReceiptViewController {
    @objc private func onHome() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
