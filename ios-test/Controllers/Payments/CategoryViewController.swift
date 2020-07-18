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
    private var refreshControl: UIRefreshControl!
    private var tapToReload: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setup()
        getCategories()
    }
}

//MARK: Setup View
extension CategoryViewController {
    private func setup() {
        view.backgroundColor = .white
        
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
        
        let safeArea = view.safeAreaLayoutGuide
        
        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}

//MARK: CollectionView Methods
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count =  viewModel.categoryCellData.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.categoryCellID, for: indexPath) as! CategoryCell
        cell.categoryCell = viewModel.categoryCellData[indexPath.row]
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


//MARK: Class Methods
extension CategoryViewController {
    private func getCategories() {
        activityIndicator.startAnimating()
        
        viewModel.getCateogries { [weak self] error in
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.onTapToReload()
            
            if let err = error {
                self?.errorAlert(with: ErrorService.handle(error: err))
                return
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    private func onTapToReload() {
        if viewModel.categoryCellData.count > 0 {
            tapToReload?.removeFromSuperview()
            return
        }
        
        if tapToReload != nil {
            return
        }
        
        tapToReload = UILabel()
        tapToReload?.translatesAutoresizingMaskIntoConstraints = false
        tapToReload?.text = "Tap To Reload"
        tapToReload?.isUserInteractionEnabled = true
        tapToReload?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reloadData)))
        
        view.addSubview(tapToReload!)
        
        let safeArea = view.safeAreaLayoutGuide
        
        tapToReload?.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        tapToReload?.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    @objc private func reloadData() {
        getCategories()
    }
}
