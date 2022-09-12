//
//  ThingDetailView.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/10/22.
//

import SwiftUI

struct ThingDetailView: View {
    let thing: Thing
    
    var body: some View {
        Text(thing.value ?? "")
    }
}
