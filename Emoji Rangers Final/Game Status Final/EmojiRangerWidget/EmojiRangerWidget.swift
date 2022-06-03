/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A widget that shows the avatar for a single character.
*/

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    
    typealias Intent = DynamicCharacterSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    func recommendations() -> [IntentRecommendation<DynamicCharacterSelectionIntent>] {
        return recommendedIntents()
            .map { intent in
                return IntentRecommendation(intent: intent, description: intent.hero!.displayString)
            }
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), relevance: nil, character: .spouty)
    }
    
    func getSnapshot(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), relevance: nil, character: .spouty)
        completion(entry)
    }
    
    func getTimeline(for configuration: DynamicCharacterSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let selectedCharacter = character(for: configuration)
        let endDate = selectedCharacter.fullHealthDate
        let oneMinute: TimeInterval = 60
        var currentDate = Date()
        var entries: [SimpleEntry] = []
        
        while currentDate < endDate {
            let relevance = TimelineEntryRelevance(score: Float(selectedCharacter.healthLevel))
            let entry = SimpleEntry(date: currentDate, relevance: relevance, character: selectedCharacter)
            
            currentDate += oneMinute
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
    
    func character(for configuration: DynamicCharacterSelectionIntent) -> CharacterDetail {
        if let name = configuration.hero?.identifier, let character = CharacterDetail.characterFromName(name: name) {
            // Save the last selected character to the app group.
            CharacterDetail.setLastSelectedCharacter(heroName: name)
            return character
        }
        return .spouty
    }

    private func recommendedIntents() -> [DynamicCharacterSelectionIntent] {
        return CharacterDetail.availableCharacters
            .map { character in
                let hero = Hero(identifier: character.name, display: character.name)
                let intent = DynamicCharacterSelectionIntent()
                intent.hero = hero
                return intent
            }
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    let relevance: TimelineEntryRelevance?
    let character: CharacterDetail
}

struct PlaceholderView: View {
    var body: some View {
        EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
    }
}

struct EmojiRangerWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryCircular:
            ProgressView(interval: entry.character.injuryDate...entry.character.fullHealthDate,
                         countdown: false,
                         label: { Text(entry.character.name) },
                         currentValueLabel: {
                Avatar(character: entry.character, includeBackground: false)
            })
            .progressViewStyle(.circular)
            
        case .accessoryRectangular:
            HStack(alignment: .center, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(entry.character.name)
                        .font(.headline)
                        .widgetAccentable()
                    Text("Level \(entry.character.level)")
                    Text(entry.character.fullHealthDate, style: .timer)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Avatar(character: entry.character, includeBackground: false)
            }
            
        case .accessoryInline:
            ViewThatFits {
                Text("\(entry.character.name) is healing, ready in \(entry.character.fullHealthDate, style: .relative)")
                Text("\(entry.character.avatar) ready in \(entry.character.fullHealthDate, style: .relative)")
                Text("\(entry.character.avatar) \(entry.character.fullHealthDate, style: .timer)")
            }
            
        case .systemSmall:
            ZStack {
                AvatarView(entry.character)
                    .widgetURL(entry.character.url)
                    .foregroundColor(.white)
            }
            .background(Color.gameBackground)
        default:
            ZStack {
                HStack(alignment: .top) {
                    AvatarView(entry.character)
                        .foregroundColor(.white)
                    Text(entry.character.bio)
                        .padding()
                        .foregroundColor(.white)
                }
                .padding()
                .widgetURL(entry.character.url)
            }
            .background(Color.gameBackground)
        }
    }
}

struct EmojiRangerWidget: Widget {
    private let kind: String = "EmojiRangerWidget"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicCharacterSelectionIntent.self, provider: Provider()) { entry in
            EmojiRangerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Ranger Detail")
        .description("See your favorite ranger.")
#if os(watchOS)
 .supportedFamilies([.accessoryCircular,
                    .accessoryRectangular, .accessoryInline])
#else
        .supportedFamilies([.accessoryCircular,
            .accessoryRectangular, .accessoryInline, .systemSmall, .systemMedium])
#endif
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Circular")

            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Rectangular")
            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
                .previewDisplayName("Inline")

#if os(iOS)

            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            EmojiRangerWidgetEntryView(entry: SimpleEntry(date: Date(), relevance: nil, character: .spouty))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
#endif
        }
    }
}
