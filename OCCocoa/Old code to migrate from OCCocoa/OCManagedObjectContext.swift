//
//  OCManagedObjectContext.swift
//  OCCocoa
//
//  Created by Jan Verrept on 13/12/14.
//  Copyright (c) 2014 OneClick. All rights reserved.
//

import CoreData

extension NSManagedObjectContext{
    
    public func deleteAllObjectsForEntity(entity:String){
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        do{
            let allItems = try executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for item in allItems{
                self.deleteObject(item)
            }
            
            
        }
        catch{
            // Handle fetch Error
        }
        
    }
}