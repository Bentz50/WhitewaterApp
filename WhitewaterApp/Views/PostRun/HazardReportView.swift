// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct HazardReportView: View {

    @ObservedObject var viewModel: PostRunViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.hazardsToVerify.isEmpty {
                    ContentUnavailableView(
                        "No Hazards",
                        systemImage: "checkmark.shield.fill",
                        description: Text("No hazards were reported for this section.")
                    )
                } else {
                    List(viewModel.hazardsToVerify) { hazard in
                        HazardVerifyRow(hazard: hazard, onAction: { status, notes in
                            Task {
                                try? await viewModel.verifyHazard(id: hazard.id, status: status, notes: notes)
                            }
                        })
                    }
                }
            }
            .navigationTitle("Hazard Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Hazard Verify Row

private struct HazardVerifyRow: View {
    let hazard: Hazard
    let onAction: (String, String) -> Void

    @State private var notes: String = ""
    @State private var expanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HazardIconView(size: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(hazard.type.displayName).font(.headline)
                    Text(hazard.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(expanded ? nil : 2)
                }
                Spacer()
                Button {
                    withAnimation { expanded.toggle() }
                } label: {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }

            if expanded {
                TextField("Notes (optional)", text: $notes, axis: .vertical)
                    .lineLimit(3)
                    .padding(8)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))

                HStack(spacing: 12) {
                    ActionButton(label: "Confirm", color: .orange) {
                        onAction("active", notes)
                    }
                    ActionButton(label: "Clear", color: .green) {
                        onAction("cleared", notes)
                    }
                    ActionButton(label: "Update", color: .blue) {
                        onAction("active", notes)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ActionButton: View {
    let label: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(label, action: action)
            .font(.caption.bold())
            .buttonStyle(.borderedProminent)
            .tint(color)
    }
}
