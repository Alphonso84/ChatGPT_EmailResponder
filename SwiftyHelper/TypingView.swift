//
//  TypingView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/21/23.
//

import SwiftUI

struct TypingView: View {
    @State private var textToDisplay = ""
    var fullText: String

    var body: some View {
        VStack {
            HStack {
                Text(textToDisplay)
                Spacer()
            }
            .padding(.leading)
            .padding(.leading)
            .padding(.trailing)
            .padding(.trailing)
        }
        .onAppear {
            self.animateText()
        }
    }

    func animateText() {
        var charIndex = 0.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { (timer) in
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

struct TypingView_Previews: PreviewProvider {
    static var previews: some View {
        TypingView(fullText: "")
    }
}


