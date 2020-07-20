//
//  CoreDataContext.swift
//  ios-test
//
//  Created by Huseyn Bayramov on 7/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContext {

    static let shared = CoreDataContext()

    private init() {}

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ios_test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                let errorMsg = "Unresolved error \(error), \(error.userInfo)"
                fatalError(errorMsg)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                let errorMsg = "Unresolved error \(nserror), \(nserror.userInfo)"
                fatalError(errorMsg)
            }
        }
    }

}
