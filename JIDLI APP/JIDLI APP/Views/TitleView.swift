import SwiftUI

struct TitleView: View {
    var onNext: () -> Void

    var body: some View {
        ZStack {
            VStack {
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

#Preview(traits: .landscapeRight) {
    TitleView(onNext: {})
}
