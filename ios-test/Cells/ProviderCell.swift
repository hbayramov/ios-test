//
//  ProviderCell.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/20/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ProviderCell: UITableViewCell {
    
    var viewModel: Provider? {
        didSet {
            if let model = viewModel {
                title.text = model.name
            }
        }
    }

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(title)
        
        title.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
