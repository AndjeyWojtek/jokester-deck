import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.languageManager) private var languageManager
    @State private var selectedTab: AppTab = .home

    init() {
        configureTabBarAppearance()
    }

    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                iPadRootView
            } else {
                iPhoneTabView
            }
        }
        .tint(.jGold)
        .id(languageManager.current)
    }

    private var iPadRootView: some View {
        NavigationSplitView {
            List {
                ForEach(AppTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Label(tab.title(using: languageManager), systemImage: tab.systemImage)
                            .foregroundStyle(selectedTab == tab ? Color.jGold : Color.jWhite)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(
                        selectedTab == tab ? Color.jGold.opacity(0.12) : Color.clear
                    )
                    .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
                }
            }
            .listStyle(.sidebar)
            .navigationTitle(languageManager.text("home.title"))
        } detail: {
            ZStack {
                rootView(for: selectedTab)
            }
            .id(selectedTab)
        }
    }

    private var iPhoneTabView: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases) { tab in
                rootView(for: tab)
                    .tabItem {
                        Label(tab.title(using: languageManager), systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
        .conditionalAnimation(
            .easeInOut(duration: 0.25),
            value: selectedTab,
            reduceMotion: reduceMotion
        )
    }

    @ViewBuilder
    private func rootView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            HomeView()
        case .codex:
            LibraryView()
        case .demo:
            DemoView()
        case .trivia:
            TriviaView()
        case .collection:
            CollectionView()
        }
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.jBackground)

        let normal = UITabBarItemAppearance()
        normal.normal.iconColor = UIColor(Color.jMuted)
        normal.normal.titleTextAttributes = [.foregroundColor: UIColor(Color.jMuted)]
        normal.selected.iconColor = UIColor(Color.jGold)
        normal.selected.titleTextAttributes = [.foregroundColor: UIColor(Color.jGold)]

        appearance.stackedLayoutAppearance = normal
        appearance.inlineLayoutAppearance = normal
        appearance.compactInlineLayoutAppearance = normal

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environment(\.languageManager, LanguageManager())
        .modelContainer(for: [CardGame.self, UserProgress.self], inMemory: true)
}
