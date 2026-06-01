//
//  ContentView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 20/05/2026.
//
//  de hoofdview die bepaalt welk scherm de gebruiker ziet
//

import SwiftUI

struct ContentView: View {
    // pakt het centrale brein (appviewmodel) erbij
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ZStack {
            Color(red: 0.92, green: 0.93, blue: 0.94)
                .ignoresSafeArea()

            VStack {
                // switch tussen de verschillende schermen o.b.v de state
                switch viewModel.route {
                case .title:
                    TitleView(onNext: { viewModel.route = .foreword })
                    
                case .foreword:
                    ForewordView(
                        onBack: { viewModel.route = .title },
                        onNext: { viewModel.route = .dashboard }
                    )
                    
                case .dashboard:
                    DashboardView(
                        items: viewModel.items,
                        onNavigateBack: {
                            viewModel.route = .foreword
                        },
                        onStartStory: { selectedId in
                            viewModel.startStory(id: selectedId)
                        },
                        onToggleAudio: { soundId in
                            viewModel.toggleAudio(for: soundId)
                        }
                    )
                    
                case .story:
                    StoryView(viewModel: viewModel, idol: viewModel.selectedIdol)
                }
            }
        }
        .onAppear {
            // start direct met luisteren naar nfc scans/firebase zodra de app opent
            viewModel.listenToItemsCollection()
        }
        .statusBar(hidden: true) // verberg de ipad batterij en tijd voor full-screen experience
    }
}

#Preview(traits: .landscapeRight) {
    ContentView().environmentObject(AppViewModel())
}
