import SwiftUI

struct ForewordView: View {
    let onBack: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Text("Foreword")
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            Text("This is the foreword text. It provides an introduction or background to the content that follows in the app. It should be informative and engaging to prepare the reader for what comes next.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            HStack {
                Button(action: onBack) {
                    Text("Back")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                Button(action: onNext) {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
    }
}

#Preview {
    ForewordView(
        onBack: { print("Back pressed") },
        onNext: { print("Next pressed") }
    )
}
