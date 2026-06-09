import Foundation
import GrowthBook
import UIKit

@Observable
@MainActor
final class GrowthBookService {
    static let shared = GrowthBookService()

    enum Feature {
        static let allowGreyPart = "gb_allow_grey_part"
    }

    private static let clientKey = "sdk-ELFdCwnTUV2DaXsP"
    private static let apiHost = "https://cdn.growthbook.io"
    private static let deviceIDKey = "growthBookDeviceID"

    private(set) var sdk: GrowthBookSDK?
    private(set) var allowsGreyPart = false

    private init() {}

    func configure() {
        guard sdk == nil else { return }

        sdk = GrowthBookBuilder(
            apiHost: Self.apiHost,
            clientKey: Self.clientKey,
            attributes: defaultAttributes(),
            trackingCallback: { experiment, experimentResult in
                #if DEBUG
                print("Viewed Experiment")
                print("Experiment Id: ", experiment.key)
                print("Variation Id: ", experimentResult.variationId)
                #endif
            }
        )
        .setRefreshHandler { [weak self] _ in
            Task { @MainActor in
                self?.syncFeatureFlags()
            }
        }
        .initializer()

        syncFeatureFlags()
    }

    func setAttributes(_ attributes: [String: Any]) {
        sdk?.setAttributes(attributes: attributes)
        syncFeatureFlags()
    }

    func updateAttributes(language: AppLanguage) {
        var attributes = defaultAttributes()
        attributes["language"] = language.rawValue
        setAttributes(attributes)
    }

    func isOn(feature id: String) -> Bool {
        sdk?.isOn(feature: id) ?? false
    }

    private func syncFeatureFlags() {
        allowsGreyPart = isOn(feature: Feature.allowGreyPart)
    }

    private func defaultAttributes() -> [String: Any] {
        let deviceID = Self.persistentDeviceID()
        let deviceType = UIDevice.current.userInterfaceIdiom == .pad ? "tablet" : "mobile"

        return [
            "id": deviceID,
            "url": "jokester-deck://",
            "path": "/",
            "host": "jokester-deck",
            "query": "",
            "deviceType": deviceType,
            "browser": "app",
            "platform": "ios",
            "language": AppLanguage.stored.rawValue,
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "utmSource": "",
            "utmMedium": "",
            "utmCampaign": "",
            "utmTerm": "",
            "utmContent": ""
        ]
    }

    private static func persistentDeviceID() -> String {
        if let existing = UserDefaults.standard.string(forKey: deviceIDKey) {
            return existing
        }

        let newID = UUID().uuidString
        UserDefaults.standard.set(newID, forKey: deviceIDKey)
        return newID
    }
}
