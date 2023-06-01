/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The content view of the watchOS app.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            TableRow(hero: .panda)
            TableRow(hero: .spouty)
            TableRow(hero: .egghead)
        }
    }
}

struct TableRow: View {
    let hero: EmojiRanger
    var body: some View {
        HStack {
            Avatar(hero: hero)
            HeroNameView(hero)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
