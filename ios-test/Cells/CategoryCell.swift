//
//  CategoryCell.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CategoryCell: BaseCategoryCell {
    
    /// category cell assigned in didSelectItem
    var categoryCell: CategoryCellModel? {
        didSet {
            if let cell = categoryCell {
                title.text = cell.name
            }
        }
    }
    
    let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 5
        return view
    }()
    
    let bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Label"
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    override func setup() {
        super.setup()

        addSubview(shadowView)
        addSubview(bgView)
        bgView.addSubview(title)
        
        bgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        bgView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bgView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
        bgView.heightAnchor.constraint(equalTo: bgView.widthAnchor).isActive = true
        
        shadowView.heightAnchor.constraint(equalTo: bgView.heightAnchor).isActive = true
        shadowView.widthAnchor.constraint(equalTo: bgView.widthAnchor).isActive = true
        shadowView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        shadowView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        
        title.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalTo: bgView.widthAnchor, multiplier: 0.95).isActive = true
    }
}

