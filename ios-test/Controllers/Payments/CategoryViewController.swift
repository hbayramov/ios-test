//
//  ViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
    }
}

extension CategoryViewController {
    private func setup() {
        view.backgroundColor = .white
        
        let label: UILabel = {
            let lbl = UILabel()
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.text = "Hello World"
            return lbl
        }()
        
        view.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

