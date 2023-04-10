import CoreData
import Foundation

class DataController: ObservableObject {
    let container: NSPersistentContainer
    @Published var moc: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "DailyAnything")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        
        moc = container.viewContext
    }
}
