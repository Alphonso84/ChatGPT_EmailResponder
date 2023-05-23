import SwiftUI

struct TypingView: View {
    @State private var textToDisplay = ""
    var fullText: String

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(textToDisplay)
                        .lineLimit(nil) // Allows text to wrap onto the next line
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)

                Spacer() // Pushes VStack to the top
            }
        }
        .background(Color.black)
        .foregroundColor(.white) 
        .onAppear {
            self.animateText()
        }
    }

    func animateText() {
        var charIndex = 0.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if Int(charIndex) < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: Int(charIndex))
                textToDisplay += String(fullText[index])
                charIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
}
