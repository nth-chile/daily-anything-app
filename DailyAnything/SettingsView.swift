import SwiftUI

struct SettingsView: View {
    @AppStorage("allowReminders") private var allowReminders = true
    @Environment(\.managedObjectContext) var moc
    @State private var time = getNotificationTime()

    var body: some View {
        Form {
            Section() {
                Toggle("Allow notifications", isOn: $allowReminders)
                    .onChange(of: allowReminders) { value in
                        Task {
                            // Even if toggle is being turned off, this function will handle that too
                            await scheduleDailyNotification(moc: moc)
                        }
                    }
            }
            
            if allowReminders == true {
                Section() {
                    DatePicker(
                        "Daily notification time",
                        selection: $time,
                        displayedComponents: [.hourAndMinute]
                    ).onChange(of: time) { newValue in
                        Task {
                            print("Notif time changed.")
                            UserDefaults.standard.set(newValue, forKey: "notificationTime")
                            await scheduleDailyNotification(moc: moc)
                        }
                    }
                }
            }
        }.navigationTitle("Settings")
    }
}
