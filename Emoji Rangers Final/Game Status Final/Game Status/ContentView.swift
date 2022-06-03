/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays the list of available characters.
*/
import SwiftUI

struct ContentView: View {
    
    @State private var selection: CharacterDetail? = nil
    
    var body: some View {
        NavigationStack {
            List(CharacterDetail.availableCharacters, id: \.self, selection: $selection) { character in
                NavigationLink {
                    DetailView(character: character)
                } label: {
                    TableRow(character: character)
                }
            }
            .onAppear {
                // Check for the last selected character.
                if let character = CharacterDetail.getLastSelectedCharacter() {
                    print("Last character selection: \(character)")
                }
            }
            .navigationBarTitle("Your Characters")
            .onOpenURL(perform: { (url) in
                if let match = CharacterDetail.availableCharacters.compactMap({ character in
                    url == character.url ? character : nil
                }).first {
                    selection = match
                }
            })
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
