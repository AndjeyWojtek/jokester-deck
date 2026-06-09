import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.languageManager) private var languageManager
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: Binding(
                        get: { languageManager.current },
                        set: { newLanguage in
                            languageManager.current = newLanguage
                            Task {
                                await languageManager.applyLocalization(to: modelContext)
                            }
                        }
                    )) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    } label: {
                        Label(languageManager.text("settings.language"), systemImage: "globe")
                            .foregroundStyle(Color.jWhite)
                    }
                } header: {
                    Text(languageManager.text("settings.title"))
                        .foregroundStyle(Color.jGold)
                } footer: {
                    Text(languageManager.text("settings.languageDescription"))
                        .font(.bodyText(13))
                        .foregroundStyle(Color.jMuted)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.jBackground)
            .navigationTitle(languageManager.text("settings.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(languageManager.text("common.done")) { dismiss() }
                        .foregroundStyle(Color.jGold)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .iPadSheetDetents()
    }
}

#Preview {
    SettingsView()
        .environment(\.languageManager, LanguageManager())
}
