import SwiftUI

struct NextThingView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        if let thing = getNextThing(moc) {
            ThingDetailView(thing: thing)
                .onAppear() {
                    thing.lastSeen = Date.now
                    try? moc.save()
                }
        }
    }
    
}
