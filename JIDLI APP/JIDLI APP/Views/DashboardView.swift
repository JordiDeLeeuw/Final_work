import SwiftUI


struct DashboardView: View {
    @ObservedObject var viewModel: AppViewModel
    let items: [DashboardItem]
    let onNavigateBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Back button and title
            HStack {
                Button(action: onNavigateBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
                        .padding(.leading)
                }
                Spacer()
                Text("Dashboard")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.trailing)
                Spacer()
                // Empty space to balance the back button
                Color.clear.frame(width: 44, height: 44)
            }
            .background(Color(UIColor.systemBackground))

            Divider()

            List {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.title)
                                .font(.headline)
                            Spacer()
                            Text("\(item.explored)/\(item.total)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        ProgressView(value: item.total == 0 ? 0 : Double(item.explored) / Double(item.total))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))

                        HStack {
                            Text("Explored: \(Int((Double(item.explored) / Double(max(item.total,1))) * 100))%")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                            if item.explored == item.total && item.total > 0 {
                                Button(action: { viewModel.toggleAudio(for: item.id) }) {
                                    Image(systemName: viewModel.playingIdolID == item.id ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            if item.unlocked {
                                Button("Open Verhaal") {
                                    viewModel.startStory(id: item.id)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static let sampleItems = [
        DashboardItem(id: "1", title: "Story One", explored: 3, total: 5, unlocked: true),
        DashboardItem(id: "2", title: "Story Two", explored: 5, total: 5, unlocked: true),
        DashboardItem(id: "3", title: "Story Three", explored: 0, total: 4, unlocked: false)
    ]

    static var previews: some View {
        DashboardView(
            viewModel: AppViewModel(),
            items: sampleItems,
            onNavigateBack: {}
        )
    }
}
