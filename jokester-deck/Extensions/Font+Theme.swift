import SwiftUI
import UIKit

extension Font {
    static func display(_ size: CGFloat, relativeTo style: Font.TextStyle = .title) -> Font {
        if UIFont(name: "CinzelDecorative-Regular", size: size) != nil {
            return .custom("CinzelDecorative-Regular", size: size, relativeTo: style)
        }
        return .custom("Georgia", size: size, relativeTo: style)
    }

    static func displayBold(_ size: CGFloat, relativeTo style: Font.TextStyle = .title) -> Font {
        if UIFont(name: "CinzelDecorative-Bold", size: size) != nil {
            return .custom("CinzelDecorative-Bold", size: size, relativeTo: style)
        }
        return .custom("Georgia-Bold", size: size, relativeTo: style)
    }

    static func bodyText(_ size: CGFloat, relativeTo style: Font.TextStyle = .body) -> Font {
        if UIFont(name: "CrimsonPro-Regular", size: size) != nil {
            return .custom("CrimsonPro-Regular", size: size, relativeTo: style)
        }
        return .custom("Georgia", size: size, relativeTo: style)
    }
}
