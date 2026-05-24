import SwiftUI

struct TitleView: View {
    var onNext: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to\nOur Amazing App")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: onNext) {
                Text("Next")
                    .font(.system(size: 18, weight: .semibold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    TitleView(onNext: {})
}
