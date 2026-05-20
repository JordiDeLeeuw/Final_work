//
//  ContentView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 20/05/2026.
//
import SwiftUI
import FirebaseFirestore

struct JidliItem: Identifiable {
    let id: String
    let status: String
    let explored: Double
}

struct StoryPage {
    let pageNumber: Int
    let text: String
    let imageName: String
}

struct ContentView: View {
    @State private var items: [JidliItem] = []
    @State private var activeIdol: String? = nil
    @State private var currentPageIndex: Int = 0
    
    // Alle verhalen verzameld in één dictionary
    let stories: [String: [StoryPage]] = [
        "group": (1...18).map { StoryPage(pageNumber: $0, text: "Group - Pagina \($0) van het JIDLI concept.", imageName: "group_\($0)") },
        "jiroh": (1...18).map { StoryPage(pageNumber: $0, text: "Jiroh - Pagina \($0) van het alien K-pop verhaal.", imageName: "jiroh_\($0)") },
        "depimi": (1...18).map { StoryPage(pageNumber: $0, text: "Depimi - Pagina \($0) van het interactieve avontuur.", imageName: "depimi_\($0)") },
        "lebang": (1...18).map { StoryPage(pageNumber: $0, text: "Lebang - Pagina \($0) van de storyline.", imageName: "lebang_\($0)") }
    ]
    
    var body: some View {
        VStack {
            if let idol = activeIdol {
                storyView(for: idol)
            } else {
                dashboardView
            }
        }
        .onAppear {
            listenToItemsCollection()
        }
    }
    
    // MARK: dashboard view
    var dashboardView: some View {
        VStack(spacing: 20) {
            Text("JIDLI Dashboard")
                .font(.largeTitle)
                .bold()
            
            ForEach(items) { item in
                HStack {
                    Text(item.id.capitalized)
                        .font(.headline)
                    Spacer()
                    
                    if item.status == "unlocked" {
                        Text("\(Int(item.explored))% explored")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            startStory(id: item.id)
                        }) {
                            Text("Open Verhaal")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    } else {
                        Text("Locked")
                            .foregroundColor(.red)
                            .bold()
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    // MARK: story view
    func storyView(for idol: String) -> some View {
        // haal de specifieke array op voor het actieve idool (fallback naar lege lijst)
        let currentStory = stories[idol] ?? []
        
        return VStack(spacing: 30) {
            HStack {
                Button("◄ Terug naar Dashboard") {
                    activeIdol = nil
                }
                Spacer()
                Text("\(idol.capitalized) — Pagina \(currentPageIndex + 1)/18")
                    .foregroundColor(.gray)
            }
            .padding()
            
            // haal de huidige pagina-data op uit de array
            if let page = currentStory[safe: currentPageIndex] {
                // dynamische foto op basis van de asset naam uit de array
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    // tijdelijke fallback placeholder want er staan nog geen echte fotos in assets
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                
                // dynamische tekst
                Text(page.text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                Text("Geen tekst beschikbaar.")
                    .font(.title2)
                    .padding()
            }
            
            Spacer()
            
            // navigatie
            HStack {
                Button("Vorige") {
                    if currentPageIndex > 0 {
                        currentPageIndex -= 1
                        updateExploredProgress(for: idol)
                    }
                }
                .disabled(currentPageIndex == 0)
                
                Spacer()
                
                Button("Volgende") {
                    if currentPageIndex < currentStory.count - 1 {
                        currentPageIndex += 1
                        updateExploredProgress(for: idol)
                    }
                }
                .disabled(currentPageIndex == currentStory.count - 1)
            }
            .padding()
        }
    }
    
    // MARK: logica functies
    func startStory(id: String) {
        activeIdol = id
        
        if let savedItem = items.first(where: { $0.id == id }) {
            let totalPages = 18.0
            
            if savedItem.explored > 0 {
                let calculatedPage = Int(round((savedItem.explored / 100.0) * totalPages))
                currentPageIndex = max(0, min(calculatedPage - 1, Int(totalPages) - 1))
            } else {
                currentPageIndex = 0
                updateExploredProgress(for: id)
            }
        } else {
            currentPageIndex = 0
            updateExploredProgress(for: id)
        }
    }
    
    func listenToItemsCollection() {
        let db = Firestore.firestore()
        db.collection("items").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else { return }
            self.items = documents.map { doc in
                let data = doc.data()
                let status = data["status"] as? String ?? "locked"
                let explored = data["explored"] as? Double ?? 0.0
                return JidliItem(id: doc.documentID, status: status, explored: explored)
            }
        }
    }
    
    func updateExploredProgress(for idol: String) {
        let db = Firestore.firestore()
        let totalPages = 18.0
        let currentPage = Double(currentPageIndex + 1)
        let percentage = (currentPage / totalPages) * 100.0
        
        db.collection("items").document(idol).updateData([
            "explored": percentage
        ]) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ContentView()
}
