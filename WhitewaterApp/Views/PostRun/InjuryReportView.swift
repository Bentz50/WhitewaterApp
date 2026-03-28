// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct InjuryReportView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var description: String = ""
    @State private var severity: Severity = .minor
    @State private var isSubmitting = false
    @State private var submitted = false

    enum Severity: String, CaseIterable {
        case minor, moderate, severe

        var displayName: String { rawValue.capitalized }

        var color: Color {
            switch self {
            case .minor:    return .yellow
            case .moderate: return .orange
            case .severe:   return .red
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Injury Details") {
                    Picker("Severity", selection: $severity) {
                        ForEach(Severity.allCases, id: \.self) { s in
                            Label(s.displayName, systemImage: "cross.case.fill")
                                .foregroundStyle(s.color)
                                .tag(s)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Description")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                    }
                }

                Section {
                    Button {
                        Task { await submit() }
                    } label: {
                        if isSubmitting {
                            ProgressView().progressViewStyle(.circular).frame(maxWidth: .infinity)
                        } else {
                            Text("Submit Report").frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(description.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Injury Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Report Submitted", isPresented: $submitted) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your injury report has been submitted. Stay safe out there!")
            }
        }
    }

    private func submit() async {
        isSubmitting = true
        defer { isSubmitting = false }
        // TODO: POST /injury-reports via APIService
        try? await Task.sleep(for: .milliseconds(500))
        submitted = true
    }
}
