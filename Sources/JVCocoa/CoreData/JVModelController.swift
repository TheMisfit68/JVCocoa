//
//  JVModelController.swift
//  HAPiNest
//
//  Created by Jan Verrept on 21/07/2020.
//  Copyright © 2020 Jan Verrept. All rights reserved.
//

import CoreData

@available(OSX 10.12, *)
public class ModelController: NSPersistentContainer {

    // Adds a saveContext function to the container, to improve performance by saving the context only when there are changes
    public func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    
    public func deleteAllObjectsForEntity(entity:String){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try viewContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                viewContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }

}

