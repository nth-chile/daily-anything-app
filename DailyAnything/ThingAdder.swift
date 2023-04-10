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
                .fill(.white)
            VStack {
                TextEditor(text: $text)
                    .frame(minHeight: 100)
                    .cornerRadius(25)
                    .padding([.top, .horizontal])
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
                    .padding([.trailing, .bottom])
                }
            }
        }
        .padding()
    }
}
