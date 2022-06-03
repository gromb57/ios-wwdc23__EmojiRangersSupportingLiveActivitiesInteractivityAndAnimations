/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that shows a character's name.
*/
import SwiftUI

struct CharacterNameView: View {
    let character: CharacterDetail

    init(_ character: CharacterDetail?) {
        self.character = character ?? CharacterDetail.spouty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(character.name)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
            Text("Level \(character.level)")
                .minimumScaleFactor(0.2)
            Text("\(character.exp) XP")
                .minimumScaleFactor(0.2)
        }
    }
}
