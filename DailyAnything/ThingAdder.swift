//
//  ThingAdder.swift
//  DailyAnything
//
//  Created by Jared Salzano on 6/9/22.
//

import SwiftUI

struct ThingAdder: View {
    @Environment(\.managedObjectContext) var moc
    @State private var text = ""
    
    // TextEditor is backed by UITextView. So you need to get rid of the UITextView's backgroundColor first and then you can set any View to the background.
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.regularMaterial)
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 80)
                    .padding()
                HStack {
                    Spacer()
                    Button("Add") {
                        if !text.isEmpty {
                            let thing = Thing(context: moc)
                            thing.id = UUID()
                            thing.value = text
                            thing.lastSeen = Date.now
                            try? moc.save()
                            text = ""
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minHeight: 200)
        .padding()
    }
}
