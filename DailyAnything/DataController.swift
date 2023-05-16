import CoreData
import Foundation
import CloudKit

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    @Published var moc: NSManagedObjectContext
    
    init() {
        container = NSPersistentCloudKitContainer(name: "DailyAnything")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        #if DEBUG
        do {
            try container.initializeCloudKitSchema(options: [])
        } catch {
            print("Error initializing CloudKit schema: \(error.localizedDescription)")
        }
        #endif
        
        moc = container.viewContext
    }
}
