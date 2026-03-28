// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI
import PhotosUI

struct MediaUploadView: View {

    @ObservedObject var viewModel: PostRunViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItems: [PhotosPickerItem] = []

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 8)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Photo picker
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 10,
                        matching: .images
                    ) {
                        Label("Select Photos", systemImage: "photo.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.appTeal)
                    .padding(.horizontal)
                    .onChange(of: selectedItems) { _, newItems in
                        Task { await loadImages(newItems) }
                    }

                    // Privacy picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Visibility")
                            .font(.headline)
                            .padding(.horizontal)
                        Picker("Privacy", selection: $viewModel.mediaPrivacy) {
                            Label("Public", systemImage: "globe").tag(MediaPrivacy.public)
                            Label("Crew Only", systemImage: "person.2.fill").tag(MediaPrivacy.crew)
                            Label("Private", systemImage: "lock.fill").tag(MediaPrivacy.private)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }

                    // Thumbnail grid
                    if !viewModel.selectedImages.isEmpty {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(viewModel.selectedImages.indices, id: \.self) { i in
                                let image = viewModel.selectedImages[i]
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)

                                    Button {
                                        viewModel.selectedImages.remove(at: i)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.white, .black.opacity(0.6))
                                            .padding(4)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Upload progress
                    let progress = MediaService.shared.uploadProgress
                    if progress > 0 && progress < 1 {
                        ProgressView(value: progress)
                            .padding(.horizontal)
                        Text("Uploading… \(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Photos & Videos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func loadImages(_ items: [PhotosPickerItem]) async {
        var loaded: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                loaded.append(image)
            }
        }
        viewModel.selectedImages = loaded
    }
}
