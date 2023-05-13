//
//  WelcomeModalView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import SwiftUI

struct ModalView: View {
    @State var showingModal: Bool

    var body: some View {
        VStack {
            Text("Welcome to Swifty Helper! Swifty Helper helps make your Swift code adhere to common Swift standards. \n We hope you like it!")
                .padding()
            Button(action: {
                showingModal = false
            }) {
                Text("OK")
            }
        }
        .frame(width: 300, height: 300)  // Set the width and height to the same value
        .background(Color.primary.opacity(0.5)) // Optional: Add a background color so you can see the square
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showingModal: true)
    }
}
