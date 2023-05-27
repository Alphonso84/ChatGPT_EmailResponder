import SwiftUI
/*`TypingView` is a SwiftUI `View` simulating a typing animation effect. On initialization,
    it takes a `String` `fullText`, to be displayed in a typing-like manner. The view has a
    black background with white foreground text.

    Properties:
    - `textToDisplay`: a `@State` variable storing the part of `fullText` currently displayed.
    - `fullText`: the complete text to be displayed with a typing animation.

    Subviews:
    - `ScrollView`, `VStack`, and `HStack` structure to arrange the text.

    Methods:
    - `animateText()`: adds characters from `fullText` to `textToDisplay` every 0.05 seconds,
       creating a typing effect.
   */
struct TypingView: View {
    @State private var textToDisplay = ""
    var fullText: String
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(textToDisplay)
                        .lineLimit(nil)
                    Spacer()
                }
                .padding(.leading)
                .padding(.trailing)
                Spacer()
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
