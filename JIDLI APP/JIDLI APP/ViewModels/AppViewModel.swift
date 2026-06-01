//
//  AppViewModel.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  regelt de firebase data, de navigatie states en de audio player
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
#if canImport(Firebase)
import Firebase
import FirebaseFirestore
#endif

@MainActor
final class AppViewModel: ObservableObject {
    
    // MARK: - ui states
    // @Published betekent: als deze waardes veranderen, past het scherm zich automatisch aan
    @Published var storyPages: [StoryPage] = []
    @Published var currentPageIndex: Int = 0
    @Published var selectedIdol: String = ""
    @Published var playingIdolID: String? = nil
    @Published var exploredProgress: Double = 0 // getal tussen 0 en 1 voor de voortgangsbalk

    @Published var route: AppRoute = .title
    @Published var items: [JidliItem] = []

    @Published var storiesByIdol: [String: [StoryPage]] = [:]

    // de 4 verschillende schermen in de app
    enum AppRoute { case title, foreword, dashboard, story }
    
    // MARK: - audio setup
    private var audioPlayer: AVAudioPlayer?
    
    init() {
        // zorgt dat het geluid door de speakers komt, ook als de ipad hardware-matig op 'stil' staat.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("audio sessie setup mislukt: \(error)")
        }
    }

    // MARK: - navigatie
    func backToDashboard() {
        stopSound()
        selectedIdol = "" // reset de keuze
        route = .dashboard // ga terug naar het overzicht
    }

    // MARK: - firebase connectie
    #if canImport(Firebase)
    private var listener: ListenerRegistration?
    #endif

    // deze functie blijft constant luisteren naar firebase, als er ergens in de database 'locked' verandert naar 'unlocked' door een NFC scan, ziet de app dat meteen en update hij de schermen.
    func listenToItemsCollection() {
        #if canImport(Firebase)
        let db = Firestore.firestore()
        listener?.remove()
        listener = db.collection("items").addSnapshotListener { [weak self] snapshot, error in
            guard let self else { return }
            if let error = error {
                print("firestore error: \(error)")
                return
            }
            guard let docs = snapshot?.documents else { return }

            // vertaal de data uit de database naar JidliItem structuur
            self.items = docs.map { doc in
                let data = doc.data()
                let status = data["status"] as? String ?? "locked"
                let explored = data["explored"] as? Double ?? 0.0
                return JidliItem(id: doc.documentID, status: status, explored: explored)
            }
        }
        #else
        // fake fallback data voor als firebase niet werkt
        self.items = [
            JidliItem(id: "1", status: "unlocked", explored: 0),
            JidliItem(id: "2", status: "unlocked", explored: 0),
            JidliItem(id: "3", status: "unlocked", explored: 0)
        ]
        #endif
    }

    // MARK: - voortgang opslaan
    // berekent hoe ver gebruiker is, en update de view
    func updateExploredProgress(current index: Int) {
        let total = max(storyPages.count, 1)
        let clamped = min(max(index, 0), total - 1)
        currentPageIndex = clamped
        exploredProgress = Double(clamped + 1) / Double(total)

        // bewaar dit in de firebase
        if !selectedIdol.isEmpty { persistExploredProgress(for: selectedIdol) }
    }

    // rekent hoeveel % gebruiker zit en stuur dit naar de database
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
                print("opslaan error: \(error.localizedDescription)")
            }
        }
        #endif
    }

    // MARK: - verhaal data
    
    // zoek naar story_data.json file in project en lees alle tekst en fotos
    func loadStoryData() -> [String: [StoryPage]] {
        guard let url = Bundle.main.url(forResource: "story_data", withExtension: "json") else { return [:] }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [StoryPage]].self, from: data)
            return decoded
        } catch {
            print("json laden mislukt: \(error)")
            return [:]
        }
    }

    // laadt alleen de paginas in van de idol waar gebruiker op heeft geklikt
    func preparePagesForSelectedIdol() {
        if storiesByIdol.isEmpty { storiesByIdol = loadStoryData() }
        storyPages = storiesByIdol[selectedIdol.lowercased()] ?? []
    }

    // opent een verhaal en kijkt in firebase of gebruiker al vooruitgang had
    func startStory(id: String) {
        selectedIdol = id
        preparePagesForSelectedIdol()
        
        if let savedItem = items.first(where: { $0.id == id }) {
            let totalPages = 18.0
            // als de gebruiker al % heeft opgebouwd, dan wordt opnieuw berekent welke pagina dat is
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
        route = .story // navigeer naar het story scherm
    }

    // MARK: - pagina controls
    func goToPreviousPage() {
        updateExploredProgress(current: max(currentPageIndex - 1, 0))
    }

    func goToNextPage(maxPage: Int = 17) {
        let next = min(currentPageIndex + 1, min(maxPage, storyPages.count - 1))
        updateExploredProgress(current: next)
    }

    // MARK: - audio speler
    
    // checkt of het liedje al speelt. ja = stop, nee = speel af
    func toggleAudio(for idol: String) {
        if playingIdolID == idol { stopSound() } else { playSound(for: idol) }
    }

    // zoekt naar een mp3 bestand met de naam van de idol en start deze
    func playSound(for idol: String) {
        let fileName = idol.lowercased()
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("audio file niet gevonden: \(idol)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            playingIdolID = idol
        } catch {
            print("play error: \(error)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        playingIdolID = nil
    }

    // MARK: - view helpers
    func isPlaying(idol: String) -> Bool { playingIdolID == idol }
    func isGroup(idol: String) -> Bool { idol.lowercased() == "group" }
    
    // de audio balk verschijnt voor idols op pagina 13, en voor de group op pagina 14
    func playPausePageIndex(for idol: String) -> Int { isGroup(idol: idol) ? 14 : 13 }

    // vertaal database data voor het dashboard
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
