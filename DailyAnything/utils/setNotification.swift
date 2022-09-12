//
//  setNotification.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/22/22.
//

import CoreData
import UserNotifications

func setNotification (
    moc: NSManagedObjectContext,
    date: Date = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!
) async {
    let maybeThing = getNextThing(moc)
    
    guard let thing = maybeThing else {
        print("Error in setNotification: could not get next thing")
        return
    }
    
    let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = thing.value ?? "Unknown value"
    content.sound = UNNotificationSound.default
    // Using the same identifier should replace any existing ones of same id
    let request = UNNotificationRequest(identifier: "DailyThingReminder", content: content, trigger: trigger)
    
    do {
        try await UNUserNotificationCenter.current().add(request)
    } catch {
        print("Error in setNotification: \(error)")
    }
}


