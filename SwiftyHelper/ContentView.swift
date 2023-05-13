//
//  ContentView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    let APIKey = ""
    @State private var code = ""
    @State private var analysis = ""
    @State private var showingModal = false
    @State private var isLoading = false
    
    
    var body: some View {
        HSplitView {
            VStack {
                Text("Paste your Swift code below:")
                    .padding()
                
                TextEditor(text: $code)
                    .border(Color.black, width: 1)
                    .padding()
                
                Button(action: {
                    analyzeCode(code)
                }) {
                    Text("Analyze Code")
                }
                .padding()
            }
            
            VStack {
                Text("Swifty Tips:")
                    .padding()
                if isLoading {
                    ProgressView() // Shows a loading spinner
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the spinner
                } else {
                    TextEditor(text: $analysis)
                        .disabled(true)
                        .border(Color.black, width: 1)
                        .padding()
                    
                    Button(action: copyToClipboard) {
                        Text("Copy Analysis to Clipboard")
                    }
                    .padding()
                }
            }
            
        }
        .background(Color.secondary.opacity(0))
        .onAppear(perform: checkFirstLaunch)
        .sheet(isPresented: $showingModal) {
            ModalView(showingModal: showingModal)
        }
    }
    
    
    func analyzeCode(_ code: String) {
        self.isLoading = true
        let customPrompt = "Can you analyze the following Swift code and give me a short example of how it can be improved according to proper Swift standards? \(code)."
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": customPrompt]
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.analysis = content
                            self.speakText(content)
                        }
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
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
    
    func speakText(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
