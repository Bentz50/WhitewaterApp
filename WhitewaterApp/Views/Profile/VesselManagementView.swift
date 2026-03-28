// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct VesselManagementView: View {

    @ObservedObject var viewModel: ProfileViewModel
    @State private var showAddSheet = false
    @State private var errorMessage: String?

    var body: some View {
        List {
            ForEach(viewModel.vessels) { vessel in
                VesselRow(vessel: vessel) {
                    Task {
                        do { try await viewModel.setDefaultVessel(id: vessel.id) }
                        catch { errorMessage = error.localizedDescription }
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let id = viewModel.vessels[index].id
                    Task {
                        do { try await viewModel.deleteVessel(id: id) }
                        catch { errorMessage = error.localizedDescription }
                    }
                }
            }
        }
        .navigationTitle("My Boats")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddSheet = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddVesselSheet { vessel in
                Task {
                    do {
                        try await viewModel.addVessel(vessel)
                        showAddSheet = false
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .alert("Error", isPresented: .init(get: { errorMessage != nil }, set: { if !$0 { errorMessage = nil } })) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .task { await viewModel.loadVessels() }
    }
}

// MARK: - Vessel Row

private struct VesselRow: View {
    let vessel: Vessel
    let setDefault: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: vesselIcon(vessel.type))
                .font(.title2)
                .foregroundStyle(Color.appTeal)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(vessel.name).font(.headline)
                    if vessel.isDefault {
                        Label("Default", systemImage: "checkmark.seal.fill")
                            .font(.caption2)
                            .foregroundStyle(Color.appTeal)
                            .labelStyle(.iconOnly)
                    }
                }
                if let brand = vessel.brand, let model = vessel.model {
                    Text("\(brand) \(model)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else if let brand = vessel.brand {
                    Text(brand).font(.caption).foregroundStyle(.secondary)
                }
                Text(vessel.type.displayName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            if !vessel.isDefault {
                Button("Set Default", action: setDefault)
                    .font(.caption)
                    .buttonStyle(.bordered)
                    .tint(Color.appTeal)
            }
        }
        .padding(.vertical, 4)
    }

    private func vesselIcon(_ type: VesselType) -> String {
        switch type {
        case .kayak: return "figure.water.fitness"
        case .canoe: return "oar.2.crossed"
        case .raft:  return "ferry"
        }
    }
}

// MARK: - Add Vessel Sheet

private struct AddVesselSheet: View {
    let onAdd: (Vessel) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var type: VesselType = .kayak

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    Picker("Type", selection: $type) {
                        ForEach(VesselType.allCases, id: \.self) { t in
                            Text(t.displayName).tag(t)
                        }
                    }
                    TextField("Name", text: $name)
                    TextField("Brand (optional)", text: $brand)
                    TextField("Model (optional)", text: $model)
                }
            }
            .navigationTitle("Add Vessel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let vessel = Vessel(
                            id: 0,
                            userId: 0,
                            type: type,
                            name: name,
                            brand: brand.isEmpty ? nil : brand,
                            model: model.isEmpty ? nil : model,
                            isDefault: false
                        )
                        onAdd(vessel)
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
