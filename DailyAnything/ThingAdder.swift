import SwiftUI

struct ThingAdder: View {
    @Environment(\.managedObjectContext) var moc
    @FocusState private var isFocused: Bool
    @State private var text = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .cornerRadius(20)
                    .focused($isFocused)
                    .padding([.top, .horizontal])
                HStack {
                    if isFocused {
                        Button("Cancel") {
                            text = ""
                            isFocused.toggle()
                        }
                        .padding([.leading, .bottom])
                    }
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
                    .padding([.trailing, .bottom])
                }
            }
        }
    }
}
