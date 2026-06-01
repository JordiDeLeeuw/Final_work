//
//  TitleView.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 24/05/2026.
//
//  opstartscherm van de app
//

import SwiftUI

struct TitleView: View {
    //wordt aangeroepen als je op nextbutton drukt om naar foreword te gaan
    var onNext: () -> Void

    var body: some View {
        ZStack {
            VStack {
                // logo section bovenaan
                HStack(spacing: 14) {
                    Image("Symbol_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 61)
                    
                    Image("Name_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(.top, 20)
                }
                .padding(.top, 71)
                
                Spacer()
                
                //titel in het midden met overlay
                ZStack {
                    VStack(spacing: 20) {
                        Text("UNIDENTIFIED")
                            .font(.custom("Gibson-Bold", size: 104))
                            .foregroundColor(Color("my_yellow"))
                        
                        Text("OBJECT")
                            .font(.custom("Gibson-Bold", size: 105))
                            .foregroundColor(Color("my_cyan"))
                    }
                    
                    Image("Pink_Frivolous")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500)
                        .offset(y: 0)
                }
                .offset(y: -38)
                
                Spacer()
                
                // nextbutton onderaan
                Button(action: onNext) {
                    Image("next_button")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                .padding(.bottom, 60)
            }
        }
    }
}
