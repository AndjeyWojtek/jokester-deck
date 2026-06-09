import SwiftUI
import SwiftData

@main
struct JokesterDeckApp: App {
    @State private var languageManager = LanguageManager()

    var sharedModelContainer: ModelContainer = ModelContainerFactory.make()

    init() {
        GrowthBookService.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.languageManager, languageManager)
                .environment(\.locale, languageManager.current.locale)
                .environment(\.layoutDirection, languageManager.current.isRTL ? .rightToLeft : .leftToRight)
                .preferredColorScheme(.dark)
                .task {
                    await GameDataLoader.seedIfNeeded(context: sharedModelContainer.mainContext)
                }
                .onChange(of: languageManager.current) { _, newLanguage in
                    LocalizationService.shared.setLanguage(newLanguage)
                    GrowthBookService.shared.updateAttributes(language: newLanguage)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
