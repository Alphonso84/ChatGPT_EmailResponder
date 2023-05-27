//
//  WelcomeModalView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import SwiftUI

struct ModalView: View {
    @Binding var showingModal: Bool

    var body: some View {
        VStack {
            Text("Welcome to EmailResponder! Powered by ChatGPT; EmailResponder composes email responses so you don't have to. \n We hope you like it!")
                .padding()
            Button(action: {
                showingModal = false
            }) {
                Text("OK")
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.primary.opacity(0.5)) 
    }
}


struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(showingModal: .constant(true))
    }
}
