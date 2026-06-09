import SwiftUI

extension Animation {
    static func optional(_ animation: Animation?, reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : animation
    }
}

extension View {
    @ViewBuilder
    func conditionalAnimation<V: Equatable>(
        _ animation: Animation?,
        value: V,
        reduceMotion: Bool
    ) -> some View {
        if reduceMotion {
            self
        } else {
            self.animation(animation, value: value)
        }
    }
}
