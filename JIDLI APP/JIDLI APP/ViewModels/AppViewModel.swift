import Foundation
import SwiftUI
import Combine
import AVFoundation
#if canImport(Firebase)
import Firebase
import FirebaseFirestore
#endif

struct StoryPage: Codable, Identifiable, Equatable {
    let pageNumber: Int
    let text: String
    let imageName: String
    var id: Int { pageNumber }

    enum CodingKeys: String, CodingKey {
        case pageNumber
        case text
        case imageName
    }
}

@MainActor
final class AppViewModel: ObservableObject {
    // MARK: - Published UI State
    @Published var storyPages: [StoryPage] = []
    @Published var currentPageIndex: Int = 0
    @Published var selectedIdol: String = ""
    @Published var playingIdolID: String? = nil
    @Published var exploredProgress: Double = 0 // 0...1

    @Published var route: AppRoute = .title
    @Published var items: [JidliItem] = []

    @Published var storiesByIdol: [String: [StoryPage]] = [:]

    enum AppRoute { case title, foreword, dashboard, story }

    // MARK: - Navigation callbacks previously passed around
    // These can be used by views but owned here so logic stays centralized.
    func backToDashboard() {
        stopSound()
        selectedIdol = ""
        route = .dashboard
    }

    // MARK: - Firestore
    #if canImport(Firebase)
    private var listener: ListenerRegistration?
    #endif

    func listenToItemsCollection() {
        #if canImport(Firebase)
        let db = Firestore.firestore()
        listener?.remove()
        listener = db.collection("items").addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            if let error = error {
                print("Firestore listen error: \(error)")
                return
            }
            guard let docs = snapshot?.documents else { return }

            // Map Firestore items for dashboard
            self.items = docs.map { doc in
                let data = doc.data()
                let status = data["status"] as? String ?? "locked"
                let explored = data["explored"] as? Double ?? 0.0
                return JidliItem(id: doc.documentID, status: status, explored: explored)
            }
        }
        #else
        // Mock items for non-Firebase builds
        self.items = [
            JidliItem(id: "1", status: "unlocked", explored: 0),
            JidliItem(id: "2", status: "unlocked", explored: 50),
            JidliItem(id: "3", status: "locked", explored: 0)
        ]
        #endif
    }

    // MARK: - Progress
    func updateExploredProgress(current index: Int) {
        let total = max(storyPages.count, 1)
        let clamped = min(max(index, 0), total - 1)
        currentPageIndex = clamped
        exploredProgress = Double(clamped + 1) / Double(total)
        if !selectedIdol.isEmpty { persistExploredProgress(for: selectedIdol) }
    }

    func persistExploredProgress(for idol: String) {
            #if canImport(Firebase)
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
            #endif
        }

    // MARK: - story control methods
    func loadStoryData() -> [String: [StoryPage]] {
            // Loads stories.json from bundle; expects a dictionary mapping idol id to pages
            guard let url = Bundle.main.url(forResource: "story_data", withExtension: "json") else { return [:] }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [StoryPage]].self, from: data)
            return decoded
        } catch {
            print("Failed to load stories.json: \(error)")
            return [:]
        }
    }

    func preparePagesForSelectedIdol() {
        if storiesByIdol.isEmpty { storiesByIdol = loadStoryData() }
        storyPages = storiesByIdol[selectedIdol.lowercased()] ?? []
    }

    func startStory(id: String) {
        selectedIdol = id
        preparePagesForSelectedIdol()
        if let savedItem = items.first(where: { $0.id == id }) {
            let totalPages = 18.0
            if savedItem.explored > 0 {
                let calculatedPage = Int(round((savedItem.explored / 100.0) * totalPages))
                currentPageIndex = max(0, min(calculatedPage - 1, Int(totalPages) - 1))
            } else {
                currentPageIndex = 0
                updateExploredProgress(current: 0)
            }
        } else {
            currentPageIndex = 0
            updateExploredProgress(current: 0)
        }
        route = .story
    }

    // MARK: - Paging
    func goToPreviousPage() {
        updateExploredProgress(current: max(currentPageIndex - 1, 0))
    }

    func goToNextPage(maxPage: Int = 17) {
        let next = min(currentPageIndex + 1, min(maxPage, storyPages.count - 1))
        updateExploredProgress(current: next)
    }

    // MARK: - Audio
    private var audioPlayer: AVAudioPlayer?

    func toggleAudio(for idol: String) {
        if playingIdolID == idol { stopSound() } else { playSound(for: idol) }
    }

    func playSound(for idol: String) {
        // Replace with your actual audio resource naming
        let fileName = idol.lowercased()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file not found for idol: \(idol)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            playingIdolID = idol
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        playingIdolID = nil
    }

    // MARK: - Helpers used by StoryView
    func isPlaying(idol: String) -> Bool { playingIdolID == idol }
    func isGroup(idol: String) -> Bool { idol.lowercased() == "group" }
    func playPausePageIndex(for idol: String) -> Int { isGroup(idol: idol) ? 14 : 13 }

    var dashboardItems: [DashboardItem] {
        let totalPages = 18
        return items.map { item in
            let exploredPages = Int((item.explored / 100.0 * Double(totalPages)).rounded())
            return DashboardItem(
                id: item.id,
                title: item.id,
                explored: min(max(exploredPages, 0), totalPages),
                total: totalPages,
                unlocked: item.status != "locked"
            )
        }
    }
}

