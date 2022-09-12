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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
