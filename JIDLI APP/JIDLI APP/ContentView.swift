//
//  ContentView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 20/05/2026.
//
import SwiftUI
import FirebaseFirestore
import AVFoundation

struct JidliItem: Identifiable {
    let id: String
    let status: String
    let explored: Double
}

struct StoryPage: Codable, Identifiable {
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

var audioPlayer: AVAudioPlayer?

struct ContentView: View {
    @State private var items: [JidliItem] = []
    @State private var activeIdol: String? = nil
    @State private var currentPageIndex: Int = 0
    @State private var activeScreen: String = "title"
    @State private var playingIdolID: String? = nil
    
    // alle verhalen verzameld in één dictionary
    // we laden de verhalen uit de json
    let stories: [String: [StoryPage]] = loadStoryData()
    
    var body: some View {
        ZStack {
            Color(red: 0.91, green: 0.93, blue: 0.94)
                .ignoresSafeArea()
            
            VStack {
                if activeScreen == "title" {
                    titleView
                } else if activeScreen == "foreword" {
                    forewordView
                } else {
                    if let idol = activeIdol {
                        storyView(for: idol)
                    } else {
                        dashboardView
                    }
                }
            }
        }
        .onAppear {
            listenToItemsCollection()
        }
        .statusBar(hidden: true) // dit verbergt de klok en batterij over de HELE app!
    }


// MARK: start scherm
var titleView: some View {
    VStack(spacing: 40) {
        Spacer()
        Text("UNIDENTIFIED\nfrivolous\nOBJECT")
            .font(.system(size: 60, weight: .black))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
        
        Button(action: {
            activeScreen = "foreword"
        }) {
            Text("Next")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        Spacer()
    }
}

// MARK: foreword scherm
var forewordView: some View {
    VStack(spacing: 30) {
        Spacer()
        Text("FIRST EXPERIENCE")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.black)
        
        Text("hier komt de tekst van je tweede pagina te staan...")
            .font(.body)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding()
        
        Spacer()
        
        HStack {
            Button(action: {
                activeScreen = "title"
            }) {
                Text("◄ Back")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                activeScreen = "dashboard"
            }) {
                Text("Next ➔")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
    .padding(40)
}

// MARK: dashboard view
var dashboardView: some View {
    VStack(spacing: 20) {
        HStack {
            Button(action: {
                activeScreen = "foreword"
            }) {
                Text("◄ Back")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(.horizontal)
        
        Text("JIDLI Dashboard")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.black)
        
        ForEach(items) { item in
            HStack {
                Text(item.id.capitalized)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                
                if item.status == "unlocked" {
                    Text("\(Int(item.explored))% explored")
                        .foregroundColor(.gray)
                    
                    if Int(item.explored) == 100 {
                        Button(action: {
                            toggleAudio(named: item.id)
                        }) {
                            Image(systemName: playingIdolID == item.id ? "pause.fill" : "music.note")
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                    
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
            .background(Color.white.opacity(0.6))
            .cornerRadius(10)
        }
    }
    .padding()
}

// MARK: story view
func storyView(for idol: String) -> some View {
    let currentStory = stories[idol] ?? []
    
    return ZStack {
        // laag 1: de achtergrondafbeelding
        if currentStory[safe: currentPageIndex] != nil {
            GeometryReader { geometry in
                Image("\(idol.capitalized)_\(currentPageIndex + 1)")
                    .resizable()
                    .scaledToFill()
                    // afbeeldingen moeten exact de framegrootte zijn van de iPad
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped() // snijd de rest af
            }
            .ignoresSafeArea()
        } else {
            Color(red: 0.91, green: 0.93, blue: 0.94)
                .ignoresSafeArea()
        }
        
        // laag 2: de content-laag (blijft ALTIJD strak binnen de ipad-schermranden)
        VStack {
            // topbar met navigatie
            HStack {
                Button(action: {
                    stopSound()
                    activeIdol = nil
                }) {
                    Text("◄ Terug naar Dashboard")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Text("\(idol.capitalized) — Pagina \(currentPageIndex + 1)/18")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(10)
            }
            .padding(.top, 20) 
            .padding(.horizontal, 20)
            
            Spacer()
            
            // de mocktekst
            if let page = currentStory[safe: currentPageIndex] {
                Text(page.text)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(12)
            }
            
            // play/pause button laadt bovenop de achtergrond
            if idol == "group" {
                if currentPageIndex == 14 { playAudioButton(for: idol) }
            } else {
                if currentPageIndex == 13 { playAudioButton(for: idol) }
            }
            
            Spacer()
            
            // onderbalk met navigatie
                            HStack {
                                // De knop toont NU ENKEL als we NIET op de eerste pagina (index 0) zijn
                                if currentPageIndex > 0 {
                                    Button(action: {
                                        currentPageIndex -= 1
                                        stopSound()
                                        updateExploredProgress(for: idol)
                                    }) {
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
                                
                                // De knop toont ENKEL als we nog NIET op de laatste pagina zijn
                                if currentPageIndex < currentStory.count - 1 {
                                    Button(action: {
                                        currentPageIndex += 1
                                        stopSound()
                                        updateExploredProgress(for: idol)
                                    }) {
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
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
        }
    }
}

// MARK: audio component
func playAudioButton(for idol: String) -> some View {
    let isCurrentIdolPlaying = (playingIdolID == idol)
    
    return Button(action: {
        toggleAudio(named: idol)
    }) {
        HStack(spacing: 12) {
            Image(systemName: isCurrentIdolPlaying ? "pause.fill" : "play.fill")
                .font(.title2)
            Text(isCurrentIdolPlaying ? "PAUSE SONG" : "PLAY SONG")
                .font(.headline)
                .tracking(1)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background(Color.black)
        .cornerRadius(30)
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

// MARK: sound engine helper functies
func toggleAudio(named soundName: String) {
    if playingIdolID == soundName {
        stopSound()
    } else {
        if playingIdolID != nil {
            stopSound()
        }
        playSound(named: soundName)
    }
}

func playSound(named soundName: String) {
    if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") ?? Bundle.main.url(forResource: soundName, withExtension: "m4a") {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            playingIdolID = soundName
        } catch {
            print("Error: kon audiobestand \(soundName) niet afspelen.")
        }
    } else {
        print("Error: audiobestand \(soundName) niet gevonden.")
    }
}

func stopSound() {
    audioPlayer?.stop()
    playingIdolID = nil
}
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview(traits: .landscapeRight) {
    ContentView()
}

