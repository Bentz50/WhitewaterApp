// Copyright © 2026 BentzTech LLC. All rights reserved.

import SwiftUI

struct EventCalendarView: View {

    @StateObject private var viewModel = EventsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Event type filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(label: "All", isActive: viewModel.selectedEventType == nil) {
                            viewModel.filterByType(nil)
                        }
                        ForEach(EventType.allCases, id: \.self) { type in
                            FilterChip(label: type.displayName, isActive: viewModel.selectedEventType == type) {
                                viewModel.filterByType(viewModel.selectedEventType == type ? nil : type)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }

                if viewModel.isLoading && viewModel.events.isEmpty {
                    ProgressView("Loading events…").frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.events.isEmpty {
                    ContentUnavailableView(
                        "No Events",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("No upcoming events found in your area.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List(viewModel.events.sorted { $0.startDate < $1.startDate }) { event in
                        EventCard(event: event)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .refreshable { await viewModel.loadEvents() }
                }
            }
            .navigationTitle("Events")
            .task { await viewModel.loadEvents() }
        }
    }
}

// MARK: - Event Card

private struct EventCard: View {
    let event: Event

    private var dateRange: String {
        let start = event.startDate.formatted(date: .abbreviated, time: .omitted)
        let end   = event.endDate.formatted(date: .abbreviated, time: .omitted)
        return start == end ? start : "\(start) – \(end)"
    }

    var body: some View {
        HStack(spacing: 14) {
            // Type icon
            RoundedRectangle(cornerRadius: 12)
                .fill(typeColor(event.type).opacity(0.15))
                .frame(width: 52, height: 52)
                .overlay {
                    Image(systemName: event.type.icon)
                        .font(.title2)
                        .foregroundStyle(typeColor(event.type))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title).font(.headline).lineLimit(1)
                Label(dateRange, systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let organizer = event.organizer {
                    Label(organizer, systemImage: "person.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(event.type.displayName)
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(typeColor(event.type).opacity(0.12), in: Capsule())
                    .foregroundStyle(typeColor(event.type))
            }

            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.tertiary).font(.caption)
        }
        .padding(12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
    }

    private func typeColor(_ type: EventType) -> Color {
        switch type {
        case .race:          return .orange
        case .festival:      return .purple
        case .cleanup:       return .green
        case .safety_course: return .blue
        case .dam_release:   return .cyan
        case .volunteer:     return .mint
        }
    }
}

// MARK: - Filter Chip

private struct FilterChip: View {
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption.bold())
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isActive ? Color.appTeal : Color(.systemGray5), in: Capsule())
                .foregroundStyle(isActive ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isActive)
    }
}
