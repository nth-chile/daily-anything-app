//
//  SettingsView.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/15/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("allowReminders") private var allowReminders = true
    @Environment(\.managedObjectContext) var moc
    @State private var time = Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!

    var body: some View {
        Form{
            Section() {
                Toggle("Allow reminders", isOn: $allowReminders)
            }
            if allowReminders == true {
                Section() {
                    DatePicker(
                        "Times",
                        selection: $time,
                        displayedComponents: [.hourAndMinute]
                    ).onChange(of: time) { newValue in
                        Task {
                            await setNotification(moc: moc, date: newValue)
                        }
                    }
                }
            }
        }.navigationTitle("Settings")
    }
}
