// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct FeelingLuckyView: View {

    let river: River
    let onTryAnother: () -> Void
    let onSelect: () -> Void

    @State private var paddleOffset: CGFloat = 0
    @State private var animating = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                // Animated paddle icon
                Image(systemName: "figure.water.fitness")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.appTeal)
                    .offset(x: paddleOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                            paddleOffset = 12
                        }
                    }

                VStack(spacing: 8) {
                    Text("Feeling Lucky?")
                        .font(.largeTitle.bold())
                    Text("We found a great paddle for you!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // River card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(river.name)
                                .font(.title2.bold())
                            Text(river.state)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(river.awRating.displayName)
                            .font(.headline.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.appTeal.opacity(0.15), in: Capsule())
                            .foregroundStyle(Color.appTeal)
                    }

                    if let desc = river.description {
                        Text(desc)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }

                    HStack(spacing: 16) {
                        if let miles = river.lengthMiles {
                            Label("\(String(format: "%.1f", miles)) mi", systemImage: "ruler")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let runnable = river.isRunnable {
                            Label(runnable ? "Runnable" : "Check conditions",
                                  systemImage: runnable ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(runnable ? .green : .orange)
                        }
                    }
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)

                // Why it was suggested
                Text("✨ Based on your skill level and nearby conditions")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Spacer()

                // Action buttons
                VStack(spacing: 12) {
                    Button {
                        onSelect()
                    } label: {
                        Text("Let's Go!")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.appTeal)

                    Button {
                        onTryAnother()
                    } label: {
                        Label("Try Another", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.appTeal)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
    }
}
