import Foundation
import SwiftData

enum ModelContainerFactory {
    private static let schema = Schema([
        CardGame.self,
        UserProgress.self
    ])

    static func make() -> ModelContainer {
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        if let container = try? ModelContainer(for: schema, configurations: [configuration]) {
            return container
        }

        deletePersistentStore(at: configuration.url)
        resetSeedFlags()

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private static func deletePersistentStore(at url: URL?) {
        guard let url else { return }

        let related = [
            url,
            URL(fileURLWithPath: url.path + "-wal"),
            URL(fileURLWithPath: url.path + "-shm")
        ]

        for fileURL in related where FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
    }

    private static func resetSeedFlags() {
        UserDefaults.standard.removeObject(forKey: "didSeedData")
        UserDefaults.standard.removeObject(forKey: "didMigrateSlugs")
    }
}
