import SwiftUI

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ThingDetailView: View {
    @ObservedObject var thing: Thing
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var uncDelegate: UNCDelegate
    @State private var savedText: String
    @State private var text: String
    @State private var isEditing = false
    @State private var height: CGFloat = .zero
    @State private var isDeleteAlertPresented = false
    
    init(thing: Thing) {
        self.thing = thing
        _savedText = State(wrappedValue: thing.value ?? "")
        _text = State(wrappedValue: thing.value ?? "")
    }
    
    var body: some View {
        VStack {
            VStack {
                ScrollView {
                    ZStack(alignment: .leading) {
                        Text(text)
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity)
                            .background(
                                GeometryReader {
                                    Color.clear.preference(
                                        key: ViewHeightKey.self,
                                        value: $0.frame(in: .local).size.height
                                    )
                                }
                            )
                        TextEditor(text: $text)
                            .disabled(!isEditing)
                            .foregroundColor(.primary)
                            .frame(height: height + 10)
                            .multilineTextAlignment(.leading)
                            .scrollContentBackground(.hidden)
                    }
                    .onPreferenceChange(ViewHeightKey.self) { height = $0 }
                }
                .frame(maxHeight: height + 10)
                .padding([.horizontal, .top])
                HStack {
                    if isEditing {
                        Button ("Cancel", role: .destructive) {
                            text = savedText
                            isEditing.toggle()
                        }
                    }
                    Spacer()
                    if isEditing {
                        Button ("Save") {
                            thing.value = withSingleNewline(text)
                            try? moc.save()
                            savedText = text
                            isEditing.toggle()
                        }
                    } else {
                        Button ("Edit") {
                            isEditing.toggle()
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.regularMaterial)
            )
            Spacer()
            Button("Delete", role: .destructive) {
                isDeleteAlertPresented.toggle()
            }
            .padding()
        }
        .padding(.horizontal)
        .alert(isPresented: $isDeleteAlertPresented) {
            Alert(
                title: Text("Delete"),
                message: Text("Are you sure you want to delete this Thing?"),
                primaryButton: .cancel(
                    Text("Cancel")
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        moc.delete(thing)
                        try? moc.save()
                        uncDelegate.navigationPath.removeLast()
                    }
                )
            )
        }
    }
}
