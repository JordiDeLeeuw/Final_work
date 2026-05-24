import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: AppViewModel
    let idol: String

    private var isPlaying: Bool { viewModel.isPlaying(idol: idol) }
    private var playPausePageIndex: Int { viewModel.playPausePageIndex(for: idol) }

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height

                Image("\(idol.capitalized)_\(viewModel.currentPageIndex + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                HStack {
                    Button(action: { viewModel.backToDashboard() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Text("Page \(viewModel.currentPageIndex + 1)/18")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.4))
                        .cornerRadius(20)
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Spacer()

                if let page = viewModel.storyPages[safe: viewModel.currentPageIndex] {
                    Text(page.text)
                        .font(.title2)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 16)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }

                Spacer()

                if viewModel.currentPageIndex == playPausePageIndex {
                    Button(action: { viewModel.toggleAudio(for: idol) }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 20)
                }

                HStack {
                    if viewModel.currentPageIndex > 0 {
                        Button(action: { viewModel.goToPreviousPage() }) {
                            Text("Vorige")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.85))
                                .cornerRadius(10)
                        }
                    }

                    Spacer()

                    if viewModel.currentPageIndex < viewModel.storyPages.count - 1 && viewModel.currentPageIndex < 17 {
                        Button(action: { viewModel.goToNextPage(maxPage: 17) }) {
                            Text("Volgende")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.85))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}
