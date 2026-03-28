// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

/// Yellow triangle with a black exclamation mark — used in map overlays and lists.
struct HazardIconView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: "triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundStyle(.yellow)

            Image(systemName: "exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.28, height: size * 0.45)
                .fontWeight(.black)
                .foregroundStyle(.black)
                .offset(y: size * 0.04)
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack(spacing: 16) {
        HazardIconView(size: 24)
        HazardIconView(size: 40)
        HazardIconView(size: 60)
    }
    .padding()
}
