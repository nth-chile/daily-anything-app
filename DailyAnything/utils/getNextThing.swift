//
//  getNextThing.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/22/22.
//

import CoreData

func getNextThing(_ moc: NSManagedObjectContext) -> Thing? {
    let request: NSFetchRequest<Thing> = NSFetchRequest(entityName: "Thing")
    request.sortDescriptors = [NSSortDescriptor(key: "lastSeen", ascending: true)]
    request.fetchLimit = 1
    
    do {
        let result = try moc.fetch(request)
        
        guard result.count == 1 else {
            print("No Things")
            return nil
        }
        
        result[0].lastSeen = Date.now
        try? moc.save()
        return result[0]
    } catch {
        print("Error getting next Thing: \(error).")
    }
    
    return nil
}