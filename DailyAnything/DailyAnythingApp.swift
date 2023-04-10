import SwiftUI
import UserNotifications

@main
struct DailyAnythingApp: App {
    @StateObject private var dataController: DataController
    @State private var didCheckNotifsOnLaunch = false
    @State private var navigationPath = NavigationPath()
    private let uncDelegate = UNCDelegate()
    
    init() {
        // Instantiate DataController here so that we can use it below
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)

        UNUserNotificationCenter.current().delegate = uncDelegate
        // Set default values for UserDefaults
        UserDefaults.standard.set(true, forKey: "allowReminders")

        Task {
            // Schedule a test notif that appears in 5 seconds
            await TESTscheduleTestNotif()

            await scheduleDailyNotification(moc: dataController.moc)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                didCheckNotifsOnLaunch: $didCheckNotifsOnLaunch
            )
            .environment(\.managedObjectContext, dataController.moc)
            .environmentObject(uncDelegate)
        }
    }
}
