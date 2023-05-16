import SwiftUI
import UserNotifications

enum NavDestinations {
    case nextThing
}

struct ContentView: View {
    @FetchRequest(sortDescriptors: []) var things: FetchedResults<Thing>
    @Binding var didCheckNotifsOnLaunch: Bool
    @State private var showCustomNotifAlert = false
    @EnvironmentObject private var uncDelegate: UNCDelegate

    var body: some View {
        NavigationStack(path: $uncDelegate.navigationPath) {
            ScrollView {
                VStack {
                    ThingAdder()
                    ForEach(things) { thing in
                        NavigationLink (value: thing) {
                            ThingCard(thing: thing)
                        }
                    }
                }
            }
            .navigationTitle("Things")
            .navigationDestination(for: NavDestinations.self) { destination in
                switch destination {
                    case .nextThing: NextThingView()
                }
            }
            .navigationDestination(for: Thing.self) { thing in
                ThingDetailView(thing: thing)
            }
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
            .background(.background)
            .onAppear() {
                if !didCheckNotifsOnLaunch {
                    Task {
                        let notifSettings = await UNUserNotificationCenter.current().notificationSettings()
                        
                        if notifSettings.authorizationStatus == .denied {
                            // If user has denied notifications in the past, show a custom alert that links to settings
                            showCustomNotifAlert = true
                        } else if notifSettings.authorizationStatus == .notDetermined {
                            // If user has not denied or allowed notifications, show the system dialog
                            UNUserNotificationCenter.current()
                                .requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                        }
                        
                        didCheckNotifsOnLaunch = true
                    }
                }
            }
        }
    }
}
