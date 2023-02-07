//
//  ContentView.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/3/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var things: FetchedResults<Thing>
    @Binding var didCheckNotifsOnLaunch: Bool
    @State private var showCustomNotifAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ThingAdder()
                    ForEach(things) { thing in
                        ThingCard(thing: thing)
                    }
                }
            }
            .onAppear() {
                if !didCheckNotifsOnLaunch {
                    Task {
                        let notifSettings = await UNUserNotificationCenter.current().notificationSettings()
                        
                        if notifSettings.authorizationStatus == .denied {
                            // If user has denied notifications in the past, show a custom alert that links to settings
                            showCustomNotifAlert = true
                        } else if notifSettings.authorizationStatus == .notDetermined {
                            // If user has not denied or allowed notifications, show the system dialog
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        
                        didCheckNotifsOnLaunch = true
                    }
                }
            }
            .navigationTitle("Things")
            .toolbar {
                NavigationLink (destination: SettingsView()) {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
            .alert(isPresented: $showCustomNotifAlert) {
                Alert(
                    title: Text("Notifications"),
                    message: Text("Turn on notifications in the Settings app."),
                    primaryButton: .default(
                        Text("Dismiss")
                    ),
                    secondaryButton: .default(
                        Text("Settings"),
                        action: {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                    )
                )
            }
        }
        .navigationViewStyle(.stack)
    }
}
