//
//  Extension.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

//MARK: UIViewController
extension UIViewController {
    func errorAlert(with message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel)
            alertController.addAction(closeAction)
            self.present(alertController, animated: true)
        }
    }
}


//MARK: Date
extension Date {
    func toString(withTime showTime: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = showTime ? "dd.MM.yyyy HH:mm" : "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}

