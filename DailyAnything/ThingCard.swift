import SwiftUI

struct ThingCard: View {
    @ObservedObject var thing: Thing
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
            HStack {
                Text(thing.value ?? "")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .lineLimit(1)
        }
        .padding([.horizontal, .bottom])
    }
}
