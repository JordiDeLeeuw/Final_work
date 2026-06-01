//
//  DashboardView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  het hoofdmenu, toont de voortgang van de groep, en de losse idols.
//

import SwiftUI

struct DashboardView: View {
    let items: [JidliItem]
    let onNavigateBack: () -> Void
    let onStartStory: (String) -> Void
    
    var onToggleAudio: ((String) -> Void)? = nil
    
    let bgColor = Color(red: 0.92, green: 0.93, blue: 0.94)
    let idolOrder = ["jiroh", "depimi", "lebang"]
    
    @State private var playingIdol: String? = nil
    
    // koppel de juiste kleuren en beelden aan de specifieke idol
    func getAssets(for id: String) -> (color: Color, name: String, image: String) {
        switch id.lowercased() {
        case "jiroh": return (Color("my_yellow"), "Jiroh_name", "Jiroh_pc")
        case "depimi": return (Color("my_magenta"), "Depimi_name", "Depimi_pc")
        case "lebang": return (Color("my_cyan"), "Lebang_name", "Lebang_pc")
        default: return (Color.black, "", "")
        }
    }
    
    var body: some View {
        ZStack {
            bgColor.ignoresSafeArea()
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    
                    // MARK: - linkerkant (idols)
                    VStack(alignment: .leading) {
                        
                        // header
                        HStack(alignment: .top) {
                            VStack(alignment: .center, spacing: -30) {
                                Text("CHAPTER")
                                    .font(.system(size: 38, weight: .black))
                                
                                Image("chronicles_script")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 220)
                                    .offset(y: 1)
                                    .zIndex(1)
                                
                                Text("LIST")
                                    .font(.system(size:38, weight: .black))
                            }
                            .padding(.leading, 173)
                            .offset(y:18)
                            
                            Spacer()
                            
                            // onzichtbare placeholder
                            Color.clear
                                .frame(width: 280, height: 100)
                                .padding(.top, 10)
                        }
                        .padding(.top, 173)
                        
                        Spacer()
                        
                        // back button en fotokaarten
                        HStack(alignment: .bottom) {
                            
                            Button(action: onNavigateBack) {
                                Image("back_button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 60)
                            }
                            .offset(x:30, y:-12)
                            
                            Spacer()
                            
                            HStack(spacing: 49) {
                                ForEach(idolOrder, id: \.self) { idolId in
                                    IdolCardView(
                                        idolId: idolId,
                                        item: items.first(where: { $0.id.lowercased() == idolId }),
                                        assets: getAssets(for: idolId),
                                        playingIdol: $playingIdol,
                                        onStartStory: onStartStory,
                                        onToggleAudio: onToggleAudio
                                    )
                                }
                            }
                        }
                    }
                    .padding(0)
                    .frame(width: geometry.size.width * 0.622)
                    .frame(maxHeight: .infinity)
                    .zIndex(1)
                    
                    // MARK: - rechterkant (groep)
                    VStack(alignment: .trailing, spacing: 0) {
                        Spacer()
                        
                        GroupCardView(
                            item: items.first(where: { $0.id.lowercased() == "group" }),
                            geometry: geometry,
                            playingIdol: $playingIdol,
                            onStartStory: onStartStory,
                            onToggleAudio: onToggleAudio
                        )
                    }
                    .frame(width: geometry.size.width * 0.391)
                    .frame(maxHeight: .infinity)
                }
            }
        }
    }
}

// MARK: - losse idol view
struct IdolCardView: View {
    let idolId: String
    let item: JidliItem?
    let assets: (color: Color, name: String, image: String)
    @Binding var playingIdol: String?
    let onStartStory: (String) -> Void
    let onToggleAudio: ((String) -> Void)?
    
    @State private var isFullyRevealed: Bool
    
    init(idolId: String, item: JidliItem?, assets: (color: Color, name: String, image: String), playingIdol: Binding<String?>, onStartStory: @escaping (String) -> Void, onToggleAudio: ((String) -> Void)?) {
        self.idolId = idolId
        self.item = item
        self.assets = assets
        self._playingIdol = playingIdol
        self.onStartStory = onStartStory
        self.onToggleAudio = onToggleAudio
        
        self._isFullyRevealed = State(initialValue: item?.status == "unlocked")
    }
    
    var body: some View {
        let idolNameCap = idolId.prefix(1).uppercased() + idolId.dropFirst().lowercased()
        let progress = Int(item?.explored ?? 0.0)
        let isFullyExplored = progress == 100
        
        Button(action: {
            // gebruiker kan pas op de kaart klikken als deze via de nfc tag is unlocked
            if isFullyRevealed, let item = item { onStartStory(item.id) }
        }) {
            VStack(alignment: .leading, spacing: 9) {
                
                ZStack {
                    Image(assets.name)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 230)
                        .fixedSize(horizontal: true, vertical: false)
                }
                .frame(width: 150, height: 100)
                .clipped()
                .offset(x: 0, y: 55)
                .zIndex(1)
                
                Image(assets.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 232)
                    .clipped()
                    .saturation(isFullyRevealed ? 1.0 : 0.0)
                    .opacity(isFullyRevealed ? 1.0 : 0.8)
                    .overlay(alignment: .bottomLeading) {
                        let isPlaying = (playingIdol == item?.id)
                        
                        let svgName: String = {
                            if !isFullyExplored {
                                return "\(idolNameCap)_scan"
                            } else if isPlaying {
                                return "\(idolNameCap)_pause"
                            } else {
                                return "\(idolNameCap)_play"
                            }
                        }()
                        
                        if isFullyRevealed || !isFullyExplored {
                            Image(svgName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45)
                                .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: 1, y: 1)
                                .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: -1, y: -1)
                                .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: 1, y: -1)
                                .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: -1, y: 1)
                                .offset(x: 0, y: 23)
                                .onTapGesture {
                                    if isFullyExplored, let id = item?.id {
                                        playingIdol = (playingIdol == id) ? nil : id
                                        onToggleAudio?(id)
                                    }
                                }
                        }
                    }
                
                HStack {
                    Spacer()
                    Text(isFullyRevealed ? "\(progress)% explored" : "locked")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(assets.color)
                        .opacity(isFullyRevealed ? 1.0 : 0.4)
                }
                .frame(width: 150)
            }
            .frame(width: 150)
            .padding(.bottom, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: item?.status) { _, newValue in
            // soepele animatie als de nfc tag gescand wordt
            withAnimation(.easeInOut(duration: 0.6)) {
                isFullyRevealed = (newValue == "unlocked")
            }
        }
    }
}

// MARK: - groep view
struct GroupCardView: View {
    let item: JidliItem?
    let geometry: GeometryProxy
    @Binding var playingIdol: String?
    let onStartStory: (String) -> Void
    let onToggleAudio: ((String) -> Void)?
    
    @State private var isFullyRevealed: Bool
    
    init(item: JidliItem?, geometry: GeometryProxy, playingIdol: Binding<String?>, onStartStory: @escaping (String) -> Void, onToggleAudio: ((String) -> Void)?) {
        self.item = item
        self.geometry = geometry
        self._playingIdol = playingIdol
        self.onStartStory = onStartStory
        self.onToggleAudio = onToggleAudio
        
        self._isFullyRevealed = State(initialValue: item?.status == "unlocked")
    }
    
    var body: some View {
        let groupProgress = Int(item?.explored ?? 0.0)
        let isGroupFullyExplored = groupProgress == 100
        
        Button(action: {
            if isFullyRevealed { onStartStory("group") }
        }) {
            Image("group_space_photo")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width * 0.314, height: geometry.size.height * 0.725)
                .clipped()
                .saturation(isFullyRevealed ? 1.0 : 0.0)
                .opacity(isFullyRevealed ? 1.0 : 0.8)
                .offset(x: 3, y: 0)
                .overlay(alignment: .bottomLeading) {
                    let isGroupPlaying = (playingIdol == "group")
                    
                    let groupSvgName: String = {
                        if !isGroupFullyExplored {
                            return "Group_scan"
                        } else if isGroupPlaying {
                            return "Group_pause"
                        } else {
                            return "Group_play"
                        }
                    }()
                    
                    if isFullyRevealed || !isGroupFullyExplored {
                        Image(groupSvgName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45)
                            .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: 1, y: 1)
                            .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: -1, y: -1)
                            .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: 1, y: -1)
                            .shadow(color: Color(red: 0.92, green: 0.93, blue: 0.94), radius: 0, x: -1, y: 1)
                            .offset(x: 0, y: 30)
                            .onTapGesture {
                                if isGroupFullyExplored {
                                    playingIdol = (playingIdol == "group") ? nil : "group"
                                    onToggleAudio?("group")
                                }
                            }
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: item?.status) { _, newValue in
            withAnimation(.easeInOut(duration: 0.6)) {
                isFullyRevealed = (newValue == "unlocked")
            }
        }
        
        Text(isFullyRevealed ? "\(groupProgress)% explored" : "locked")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.black)
            .opacity(isFullyRevealed ? 1.0 : 0.4)
            .offset(x: 4,y: 2)
            .padding(.bottom, 10)
            .padding(.top,14)
    }
}
