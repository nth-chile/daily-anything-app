//
//  DailyAnythingApp.swift
//  DailyAnythingw
//
//  Created by Jared Salzano on 6/3/22.
//

import SwiftUI

@main
struct DailyAnythingApp: App {
    @StateObject private var dataController = DataController()
    @State private var didCheckNotifsOnLaunch = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(didCheckNotifsOnLaunch: $didCheckNotifsOnLaunch)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
