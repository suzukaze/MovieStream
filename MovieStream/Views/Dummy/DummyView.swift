//
//  DummyView.swift
//  MovieStream
//
//  Created by HiroeJun on 2025/07/02.
//

import SwiftUI

struct DummyView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Hello, Dummy!")
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.2))
            Spacer()
        }
    }
}

#Preview {
    DummyView()
}
