//
//  Extension.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

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

//MARK: String
extension String {
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd H:mm:ss"
        
        return dateFormatter.string(from: dt ?? Date())
    }
}

extension UIColor {
    static let alabaster = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
}
