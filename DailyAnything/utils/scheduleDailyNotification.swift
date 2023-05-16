import CoreData
import UserNotifications

func scheduleDailyNotification (moc: NSManagedObjectContext) async -> Void {
    let center = UNUserNotificationCenter.current()
    
    print("scheduleDailyNotification: Canceling")
    // Cancel existing
    center.removePendingNotificationRequests(withIdentifiers: ["dailyThingReminder"])
    
    print("scheduleDailyNotification: Checking allowReminders")
    // User can disable notifs from within the app (as opposed to Settings app). If user has them off, don't schedule
    guard UserDefaults.standard.bool(forKey: "allowReminders") != false else {
        print("scheduleDailyNotification: allowReminders is \(UserDefaults.standard.bool(forKey: "allowReminders"))")
        return
    }
    
    print("scheduleDailyNotification: Checking if there are things")
    let areThereAnyThings = getNextThing(moc) != nil
    
    // If there are no things, exit
    guard areThereAnyThings else {
        print("scheduleDailyNotification exiting early because there are no saved Things")
        return
    }
    
    print("scheduleDailyNotification: Getting notifTime")
    let date = getNotificationTime()
    print("scheduleDailyNotification: Creating notif")
    // @todo: I'm not sure which date, if any, is specified here. Today? In any case it works because it's a repeating notif
    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let content = UNMutableNotificationContent()
    content.title = "Today's thing"
    content.body = "Tap to view"
    content.sound = UNNotificationSound.default
    let request = UNNotificationRequest(identifier: "dailyThingReminder", content: content, trigger: trigger)
    
    do {
        try await center.add(request)
        print("scheduleDailyNotification success")
    } catch {
        print("Error in scheduleDailyNotification: \(error)")
    }
}
