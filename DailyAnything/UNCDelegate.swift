import UserNotifications
import SwiftUI

class UNCDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var navigationPath = NavigationPath() {
        didSet {
            print("navigationPath updated")
        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if (
            response.notification.request.identifier == "testNotif" ||
            response.notification.request.identifier == "dailyThingReminder"
        ) {
            // User tapped the reminder notification and app is not in the foreground
            // Reset navigationPath to avoid pushing multiple screens to the stack
            navigationPath = NavigationPath()
            navigationPath.append(NavDestinations.nextThing)
            completionHandler()
        }
    }
}
