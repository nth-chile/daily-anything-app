import UserNotifications

func TESTscheduleTestNotif () async -> Void {
    let trigger = UNTimeIntervalNotificationTrigger(
        timeInterval: 5,
        repeats: false
    )
    
    let content = UNMutableNotificationContent()
    content.title = "Title"
    content.body = "Body"
    content.sound = UNNotificationSound.default
    
    let request = UNNotificationRequest(
        identifier: "testNotif",
        content: content,
        trigger: trigger
    )
    
    do {
        try await UNUserNotificationCenter.current().add(request)
        print("Scheduled testNotif")
    } catch {
        print("Error in TESTscheduleTestNotif: \(error)")
    }
}

