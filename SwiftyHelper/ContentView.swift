//
//  ContentView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var code = ""
    @State private var analysis = ""
    @State private var showingModal = true
    
    var body: some View {
        HSplitView {
            VStack {
                Text("Paste your Swift code below:")
                    .padding()
                
                TextEditor(text: $code)
                    .border(Color.black, width: 1)
                    .padding()
                
                Button(action: analyzeCode) {
                    Text("Analyze Code")
                }
                .padding()
            }
            
            VStack {
                Text("Swifty Tips:")
                    .padding()
                
                TextEditor(text: $analysis)
                    .border(Color.black, width: 1)
                    .padding()
                
                Button(action: copyToClipboard) {
                    Text("Copy Analysis to Clipboard")
                }
                .padding()
            }
            
        }
        .background(Color.secondary.opacity(0))
        .onAppear(perform: checkFirstLaunch)
                .sheet(isPresented: $showingModal) {
                    ModalView(showingModal: $showingModal)
                }
    }
    
    
    func analyzeCode() {
        // Call the OpenAI API and analyze the code, then set the `analysis` variable to the result.
    }
    
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(analysis, forType: .string)
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            showingModal = true
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
    }
}

struct ModalView: View {
    @Binding var showingModal: Bool

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
