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
    @State private var alertIsPresented = false
    
    // Maybe show alert with option to go to settings and turn on notifications
    func maybeShowAlert() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        if settings.authorizationStatus != .authorized {
            alertIsPresented = true
        }
    }
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
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
            .onAppear{
                Task {
                    await maybeShowAlert()
                }
            }
            .navigationTitle("Things")
            .toolbar {
                NavigationLink (destination: SettingsView()) {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            }
            .alert(isPresented: $alertIsPresented) {
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
