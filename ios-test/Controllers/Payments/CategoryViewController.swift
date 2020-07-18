//
//  ViewController.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController {
    private let viewModel = PaymentViewModel()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getCategories()
        setup()
    }
}

//MARK: Setup View
extension CategoryViewController {
    private func setup() {
        view.backgroundColor = .white
        
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView = {
            let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.delegate = self
            cv.dataSource = self
            cv.register(CategoryCell.self, forCellWithReuseIdentifier: Constants.Cell.categoryCellID)
            cv.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            cv.backgroundColor = .clear
            cv.backgroundView = activityIndicator
            return cv
        }()
        view.addSubview(collectionView)
        
        
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
    }
}

//MARK: Requests
extension CategoryViewController {
    
    private func getCategories() {
        activityIndicator.startAnimating()
        viewModel.getCateogries { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if let err = error {
                self?.errorAlert(with: ErrorService.handle(error: err))
                return
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

//MARK: Methods
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count =  viewModel.categoryCellModels.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.categoryCellID, for: indexPath) as! CategoryCell
        cell.categoryCell = viewModel.categoryCellModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected ", indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 60) / 3
        return CGSize(width: size, height: size)
    }
}
