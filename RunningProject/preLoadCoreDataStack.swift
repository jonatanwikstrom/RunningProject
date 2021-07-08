//
//  preLoadCoreDataStack.swift
//  RunningProject
//
//  Created by Jonatan Wikström on 2021-07-08.
//

import CoreData

class preLoadCoreDataStack {
  
  static let persistentContainer: NSPersistentContainer = {
    let secondContainer = NSPersistentContainer(name: "preLoadRoutes")
    secondContainer.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return secondContainer
  }()
  
  static var secondContext: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let secondContext = persistentContainer.viewContext
    
    guard secondContext.hasChanges else {
      return
    }
    
    do {
      try secondContext.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
    

}


