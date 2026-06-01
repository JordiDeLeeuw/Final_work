//
//  StoryView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 25/05/2026.
//
//  het scherm waar gebruiker het verhaal leest en liedjes 1e keer beluisterd.
//  laadt dynamisch de achtergronden en teksten in.
//

import SwiftUI

struct StoryView: View {
    @ObservedObject var viewModel: AppViewModel
    let idol: String
    
    // haal de audio state op
    private var isPlaying: Bool { viewModel.isPlaying(idol: idol) }
    private var playPausePageIndex: Int { viewModel.playPausePageIndex(for: idol) }
    
    var body: some View {
        ZStack {
            // MARK: - achtergrond afbeelding
            GeometryReader { proxy in
                let width = proxy.size.width
                let height = proxy.size.height
                
                // zoekt het juiste beeld op basis van de idol naam en huidige pagina
                Image("\(idol.capitalized)_\(viewModel.currentPageIndex + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipped()
            }
            .ignoresSafeArea()
            
            // MARK: - interface overlay
            VStack(spacing: 0) {
                
                // top bar: terugknop en decoratieve balk
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
                
                // MARK: - tekst & audio sectie
                HStack(alignment: .top) {
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 20) {
                        // haal de tekst op via [safe:] check uit Utils
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
                        
                        // knop alleen zichtbaar als gebruiker op specifieke aduio pagina is
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
                
                // MARK: - bottom bar: navigatie pijlen
                HStack {
                    // vorige knop (of een leeg vlak op pagina 1)
                    if viewModel.currentPageIndex > 0 {
                        Button(action: { viewModel.goToPreviousPage() }) {
                            Image("Story_back")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 60)
                        }
                    } else {
                        // placeholder zodat de 'volgende' knop niet naar links schuift
                        Color.clear.frame(width: 60, height: 60)
                    }
                    
                    Spacer()
                    
                    // volgende knop (verdwijnt op de laatste pagina)
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
