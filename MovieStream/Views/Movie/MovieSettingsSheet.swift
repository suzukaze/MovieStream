//
//  MovieSettingsSheet.swift
//  MovieStream
//
//  Created by Hiroe Jun on 2025/07/15.
//

import SwiftUI

struct MovieSettingsSheet: View {
    @Binding var showSheet: Bool
    @Binding var playbackRate: Float

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Button(action: {
                showSheet = false
            }) {
                Image(systemName: "minus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.secondary)
                    .padding()
            }
            
            VStack(spacing: 16) {
                Button(String(localized: "speed.0_25")) {
                    playbackRate = 0.25
                    showSheet = false
                }
                .foregroundColor(.blue)
                
                Button(String(localized: "speed.0_5")) {
                    playbackRate = 0.5
                    showSheet = false
                }
                .foregroundColor(.blue)
                
                Button(String(localized: "speed.1_0")) {
                    playbackRate = 1.0
                    showSheet = false
                }
                .foregroundColor(.blue)

                Button(String(localized: "speed.1_25")) {
                    playbackRate = 1.25
                    showSheet = false
                }
                .foregroundColor(.blue)

                Button(String(localized: "speed.1_5")) {
                    playbackRate = 1.5
                    showSheet = false
                }
                .foregroundColor(.blue)
                
                Button(String(localized: "speed.2_0")) {
                    playbackRate = 2.0
                    showSheet = false
                }
                .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    MovieSettingsSheet(
        showSheet: .constant(true),
        playbackRate: .constant(1.0)
    )
}
