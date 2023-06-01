/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The hero selection intent handler.
*/

import Intents

class IntentHandler: INExtension, EmojiRangerSelectionIntentHandling {
    
    func provideHeroNameOptionsCollection(for intent: EmojiRangerSelectionIntent) async throws -> INObjectCollection<NSString> {
        let heros: [NSString] = EmojiRanger.allHeros.map { hero in
            hero.name as NSString
        }
        
        return INObjectCollection(items: heros)
    }
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
}
