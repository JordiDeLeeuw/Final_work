import SwiftUI

struct ForewordView: View {
    // Navigatie callbacks
    let onBack: () -> Void
    let onNext: () -> Void

    // Placeholders voor de lappen tekst uit je mockup
    // Vervang deze gerust door de echte teksten.
    let loremIpsum1 = "Welkom bij de digitale dimensie van JIDLI. Deze applicatie vormt de ultieme brug tussen jouw fysieke album en onze exclusieve virtuele wereld. Ontdek een nieuwe manier om muziek te ervaren. Stap binnen in het unieke universum van ons \n K-pop project en laat je meeslepen."
    let loremIpsum2 = "Dit is de centrale terminal waar de visuele en muzikale verhaallijnen van Jiroh, Depimi en Lebang samenkomen. Deze interface is speciaal ontworpen om jouw interactie met het object te versterken. Alles wat je hier ziet, is een direct verlengstuk van de fysieke Y2K esthetiek."
    let loremIpsum3 = "Binnen deze omgeving krijg je de volledige controle over de audiovisuele ervaring. Duik diep in de unieke achtergronden van de artiesten en luister naar de dromerige R&B en garage tracks. Deze app functioneert niet zomaar als een mediaspeler, maar als een interactief archief. Jij bepaalt het tempo waarop de geheimen van dit ruimteschip worden onthuld. Jouw ontdekkingstocht begint hier."
    let loremIpsum4 = "Bereid je voor om de grens met de digitale wereld te doorbreken. Zorg dat de fysieke merchandise binnen handbereik is voor de volgende stap. De connectie met het systeem wordt zo dadelijk tot stand gebracht. Bereid jezelf nu voor op de eerste fysieke interactie."

    var body: some View {
        ZStack {
            Color(red: 0.91, green: 0.93, blue: 0.94)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 120) {
                    // linker kolom
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
                        Text(loremIpsum1)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding(.top, 10)
                    }
                    .frame(width: 320)
                    // rechter kolom
                    VStack(alignment: .leading, spacing: 25) {
                        Text(loremIpsum2)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Text(loremIpsum3)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        Text(loremIpsum4)
                            .font(.custom("Gibson-Regular", size: 16))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, 160)
                .padding(.top, 195)
                Spacer()
                HStack {
                  
                    Button(action: onBack) {
                        Image("back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    Spacer()
                    // Next knop pijl-logo (Custom SVG)
                    Button(action: onNext) {
                        Image("next_button") // Zorg dat deze in je Assets staat!
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60) // Getweakte hoogte op basis van image_6.png
                    }
                }
                .padding(.horizontal, 30) // Padding aan de zijkanten van de bodem nav
                .padding(.bottom, 30) // Padding tot de fysieke bodem van de iPad
            }
        }
    }
}

// -----------------------------------------------------------------
// PREVIEW CONFIGURATIE (Forceren in Landscape)
// -----------------------------------------------------------------
#Preview(traits: .landscapeRight) {
    ForewordView(
        onBack: { print("Back pressed") },
        onNext: { print("Next pressed") }
    )
}
