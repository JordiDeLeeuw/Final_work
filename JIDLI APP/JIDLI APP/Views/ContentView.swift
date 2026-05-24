//
//  ContentView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 20/05/2026.
//
import SwiftUI
import FirebaseFirestore



// Keep the safe-subscript used by StoryView
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel

    var body: some View {
        ZStack {
            Color(red: 0.91, green: 0.93, blue: 0.94)
                .ignoresSafeArea()

            VStack {
                switch viewModel.route {
                case .title:
                    TitleView(onNext: { viewModel.route = .foreword })
                case .foreword:
                    ForewordView(onBack: { viewModel.route = .title }, onNext: { viewModel.route = .dashboard })
                case .dashboard:
                    DashboardView(
                        viewModel: viewModel,
                        items: viewModel.dashboardItems,
                        onNavigateBack: { viewModel.route = .foreword }
                    )
                case .story:
                    StoryView(viewModel: viewModel, idol: viewModel.selectedIdol)
                }
            }
        }
        .onAppear {
            viewModel.listenToItemsCollection()
        }
        .statusBar(hidden: true)
    }
}

#Preview(traits: .landscapeRight) {
    ContentView().environmentObject(AppViewModel())
}

