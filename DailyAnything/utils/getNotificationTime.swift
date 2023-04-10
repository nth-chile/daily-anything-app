import UserNotifications

// Get from UserDefaults the time of day to send Thing notifications
func getNotificationTime () -> Date {
    let userDefault = UserDefaults.standard.object(forKey: "notificationTime")
    
    if userDefault != nil {
        return userDefault as! Date
    }
        
    return Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
}
