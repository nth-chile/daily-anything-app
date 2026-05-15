import Foundation
import CloudKit
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    @Published var moc: NSManagedObjectContext
    
    init() {
        container = NSPersistentCloudKitContainer(name: "DailyAnything")
        
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description?.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.transactionAuthor = "app"

//        #if DEBUG
//        ChatGPT says this should happen automatically
//        do {
//            try container.initializeCloudKitSchema(options: [])
//        } catch {
//            print("Error initializing CloudKit schema: \(error.localizedDescription)")
//        }
//        #endif
        
        moc = container.viewContext
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        moc.automaticallyMergesChangesFromParent = true
    }
}
