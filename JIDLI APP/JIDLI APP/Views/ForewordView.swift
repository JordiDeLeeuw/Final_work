//
//  ForewordView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  het introductie scherm met het verhaal voor de speler begint
//

import SwiftUI

struct ForewordView: View {
    // navigatie callbacks gestuurd vanuit contentview
    let onBack: () -> Void
    let onNext: () -> Void

    // MARK: - story text
    let paragraph1 = "Welcome, earthling. We hope you received our package well. It was sent from our  ship after a long journey through space, carrying the voices and memories of JIDLI inside. \nWe decided to wrap our story into an album, since we discovered that humans seem to treasure those. What you are holding is not just a collection of objects, but the first trace of our arrival."
    let paragraph2 = "Inside this transmission, the story of Jiroh, Depimi and Lebang slowly begins to unfold. You will not receive everything at once. First, you must follow the main group story, read through the monologue and let the world reveal itself piece by piece. Somewhere inside that story, you will naturally encounter the first song. Listen closely, because by then, you will already know why it exists."
    let paragraph3 = "After the first signal reaches you, the three idols will become clearer. Their images, voices and individual stories are hidden behind the photocards you received. Scan them to unlock each personal phonebook and discover what they carry with them. Each member holds their own memories, background and song, waiting for you to find the right connection."
    let paragraph4 = "Do not rush the process. Keep the poster, photocards, stickers and speaker close while you move through the archive. The magazine will guide you through the journey of our creator, while the rest of the package pulls you deeper into ours. The system is ready to respond. All that is left is for you to begin the first interaction."

    var body: some View {
        ZStack {
            Color(red: 0.92, green: 0.93, blue: 0.94)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                
                // MARK: - text kolommen
                HStack(alignment: .top, spacing: 120) {
                    
                    // linker kolom: grote titel en eerste alinea
                    VStack(alignment: .leading, spacing: 165) {
                        ZStack {
                            VStack(spacing: 6) {
                                Text("FIRST")
                                    .font(.custom("Gibson-Bold", size: 38))
                                    .foregroundColor(.black)
                                Text("EXPERIENCE")
                                    .font(.custom("Gibson-Bold", size: 38))
                                    .foregroundColor(.black)
                            }
                            
                            Image("Colored_Introduction")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220)
                                .offset(y: -2)
                        }
                        .padding(.leading, 30)
                        
                        Text(paragraph1)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 10)
                    }
                    .frame(width: 320)
                    
                    // rechter kolom: de overige 3 alineas
                    VStack(alignment: .leading, spacing: 25) {
                        Text(paragraph2)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        
                        Text(paragraph3)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        
                        Text(paragraph4)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, 160)
                .padding(.top, 195)
                
                Spacer()
                
                // MARK: - bottom navigatie
                HStack {
                    Button(action: onBack) {
                        Image("back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    
                    Spacer()
                    
                    Button(action: onNext) {
                        Image("next_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 12)
            }
        }
    }
}
