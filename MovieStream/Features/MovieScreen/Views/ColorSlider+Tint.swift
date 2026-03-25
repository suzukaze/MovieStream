//
//  ColorSlider+Tint.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/07.
//

import SwiftUI

struct ColorSliderTintModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .environment(\._colorSliderTint, color)
    }
}

extension View {
    func tint(_ color: Color) -> some View {
        self.modifier(ColorSliderTintModifier(color: color))
    }
}

private struct ColorSliderTintKey: EnvironmentKey {
    static let defaultValue: Color = .red
}

extension EnvironmentValues {
    var _colorSliderTint: Color {
        get {
            self[ColorSliderTintKey.self]
        }
        
        set {
            self[ColorSliderTintKey.self] = newValue
        }
    }
}
