import Foundation

extension String {
    func removingHTMLEntities() -> String {
        var result = self
        if let decoded = result.removingPercentEncoding {
            result = decoded
        }

        let entities: [String: String] = [
            "&quot;": "\"",
            "&amp;": "&",
            "&apos;": "'",
            "&#039;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&nbsp;": " ",
            "&#39;": "'",
            "&#x27;": "'",
            "&#x2F;": "/",
            "&ldquo;": "\u{201C}",
            "&rdquo;": "\u{201D}",
            "&rsquo;": "\u{2019}",
            "&lsquo;": "\u{2018}"
        ]

        for (entity, replacement) in entities {
            result = result.replacingOccurrences(of: entity, with: replacement)
        }

        return result
    }
}
