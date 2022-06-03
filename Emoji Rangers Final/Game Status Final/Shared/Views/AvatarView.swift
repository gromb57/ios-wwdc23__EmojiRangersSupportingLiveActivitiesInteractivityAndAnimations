/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that shows the player's avatar.
*/
import SwiftUI

struct Avatar: View {
    var character: CharacterDetail
    var includeBackground: Bool = true

    var body: some View {
        ZStack {
            if includeBackground {
                Circle().fill(Color.gameWidgetBackground)
                    .frame(maxWidth: 50, maxHeight: 50)
            }
            Text(character.avatar)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
        }
    }
}

struct AvatarView: View {
    var character: CharacterDetail

    init(_ character: CharacterDetail) {
        self.character = character
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Avatar(character: character, includeBackground: true)
                    CharacterNameView(character)
                }
                VStack(alignment: .leading, spacing: 6) {
                        Text("HP")
                        HealthLevelShape(level: character.healthLevel)
                        .frame(height: 10)
                    Text("Healing Time")
                    Text(character.fullHealthDate, style: .timer)
                        .font(.system(.title, design: .monospaced))
                        .minimumScaleFactor(0.5)
                }
            }
        }
        .padding()
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AvatarView(CharacterDetail.spouty)
                .previewLayout(.fixed(width: 160, height: 160))
        }
    }
}
