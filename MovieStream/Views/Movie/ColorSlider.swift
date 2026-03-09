//
//  ColorSlider.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/07.
//

import SwiftUI

struct ColorSlider: UIViewRepresentable {
    @Binding var value: Double
    private var range: ClosedRange<Double>
    @Environment(\._colorSliderTint) private var tintColor: Color
    private var onEditingChanged: ((Bool) -> Void)?

    init(value: Binding<Double>,
         in range: ClosedRange<Double>,
         onEditingChanged: ((Bool) -> Void)? = nil) {
        self._value = value
        self.range = range
        self.onEditingChanged = onEditingChanged
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        let uiColor = UIColor(tintColor)
        slider.minimumTrackTintColor = uiColor
        slider.thumbTintColor = uiColor
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.editingDidBegin(_:)), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.editingDidEnd(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.minimumValue = Float(range.lowerBound)
        uiView.maximumValue = Float(range.upperBound)
        uiView.value = Float(value)
        let uiColor = UIColor(tintColor)
        uiView.minimumTrackTintColor = uiColor
        uiView.thumbTintColor = uiColor
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: ColorSlider

        init(_ parent: ColorSlider) {
            self.parent = parent
        }

        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
        
        @objc func editingDidBegin(_ sender: UISlider) {
            parent.onEditingChanged?(true)
        }

        @objc func editingDidEnd(_ sender: UISlider) {
            parent.onEditingChanged?(false)
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // デフォルト（赤）
        ColorSlider(value: .constant(0.3), in: 0...1)
        // 青で指定
        ColorSlider(value: .constant(0.5), in: 0...1).tint(.blue)
        // 緑で指定
        ColorSlider(value: .constant(0.7), in: 0...1).tint(.green)
    }
    .padding()
}
