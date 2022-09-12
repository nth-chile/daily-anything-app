//
//  ThingCard.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/10/22.
//

import SwiftUI

struct ThingCard: View {
    let thing: Thing
    
    var body: some View {
        NavigationLink (destination: ThingDetailView(thing: thing)) {
            ZStack {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.regularMaterial)
                VStack () {
                    HStack {
                        Text(thing.value ?? "")
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .padding()
    }
}
