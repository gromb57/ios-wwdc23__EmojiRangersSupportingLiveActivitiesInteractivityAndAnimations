/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The content view of the watch app.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            TableRow(character: .panda)
            TableRow(character: .spouty)
            TableRow(character: .egghead)
        }
    }
}

struct TableRow: View {
    let character: CharacterDetail
    var body: some View {
        HStack {
            Avatar(character: character)
            CharacterNameView(character)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
