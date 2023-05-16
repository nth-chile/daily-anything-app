import SwiftUI

struct ThingCard: View {
    @ObservedObject var thing: Thing
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.regularMaterial)
            HStack {
                Text(thing.value ?? "")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding()
            .lineLimit(8)
        }
    }
}
