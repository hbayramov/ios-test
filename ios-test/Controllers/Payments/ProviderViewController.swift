//
//  ProviderViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ProviderViewController: BaseViewController {
    private let viewModel: PaymentViewModel!
    private var tableView = UITableView()
    
    init(with model: PaymentViewModel) {
        self.viewModel = model
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
extension ProviderViewController {
    private func setup() {
        setupNavigationController()
        setupView()
    }
    
    private func setupNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Providers"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupView() {        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProviderCell.self, forCellReuseIdentifier: Constants.Cell.providerCellID)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}


//MARK: TableView methods
extension ProviderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel.selectedCategory?.providers?.count else {
            return 0
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.providerCellID, for: indexPath) as! ProviderCell
        cell.viewModel = viewModel.selectedCategory?.providers?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedProvider = viewModel.selectedCategory?.providers?[indexPath.row]
        onPaymentView()
    }
}

//MARK: Class methods
extension ProviderViewController {
    private func onPaymentView() {
        navigationController?.pushViewController(PaymentViewController(with: viewModel), animated: true)
    }
}
