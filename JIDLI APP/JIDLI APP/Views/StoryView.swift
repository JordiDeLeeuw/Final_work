import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: AppViewModel
    let idol: String
    
    private var isPlaying: Bool { viewModel.isPlaying(idol: idol) }
    private var playPausePageIndex: Int { viewModel.playPausePageIndex(for: idol) }
    
    var body: some View {
        ZStack {
            // 1. DE ACHTERGROND (Nu dwingen we de GeometryReader ook de Safe Area te negeren)
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                Image("\(idol.capitalized)_\(viewModel.currentPageIndex + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
            }
            .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Button(action: { viewModel.backToDashboard() }) {
                        Image("Story_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 45)
                            .offset(y: -5)
                    }
                    .padding(.leading, 20)

                    Spacer()
                    Image("Story_balk")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 420)
                        .padding(.trailing, 50)
                        .offset(x: 107, y: -5)
                }
                .padding(.top, 20)
                                // dynamische text en potentiale audio knop
                HStack(alignment: .top) {
                    Spacer()

                    VStack(alignment: .center, spacing: 20) {
                        if let page = viewModel.storyPages[safe: viewModel.currentPageIndex] {
                            ScrollView {
                                Text(page.text)
                                    .font(.custom("Gibson-Regular", size: 16))
                                    .foregroundColor(.white)
                                    .lineSpacing(6)
                                    .multilineTextAlignment(.leading)
                                    .padding(15)
                            }
                            .frame(width: 320, height: 415)
                            .background(Color.black.opacity(0.4))
                            .padding(.top, -18)
                        }
                        if viewModel.currentPageIndex == playPausePageIndex {
                            Button(action: { viewModel.toggleAudio(for: idol) }) {
                                Image(isPlaying ? "Story_pause" : "Story_play")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }
                    .padding(.trailing, 0)
                }
                                Spacer()
                HStack {
                                        if viewModel.currentPageIndex > 0 {
                        Button(action: { viewModel.goToPreviousPage() }) {
                            Image("Story_back")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                    } else {
                        Color.clear.frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    // volgende pagina
                    if viewModel.currentPageIndex < viewModel.storyPages.count - 1 && viewModel.currentPageIndex < 17 {
                        Button(action: { viewModel.goToNextPage(maxPage: 17) }) {
                            Image("Story_next")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                    } else {
                        Color.clear.frame(width: 60, height: 60)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 10)
            }
        }
    }
}
