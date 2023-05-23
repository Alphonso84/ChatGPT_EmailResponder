//
//  ContentEditorView_ViewModel.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/23/23.
//
import Cocoa
import SwiftUI

class ContentEditorView_ViewModel: ObservableObject {
    @Published var writing = ""
    @Published var analysis = ""
    @Published var isLoading = false
    @Published var showCheckmark = false
    @Published var showingModal = false
    @Published var selectedResponseStyle: ResponseStyle = .Professional
    @Published var selectedResponseLength: ResponseLength = .Short
    @Published var selectedResponseTone: ResponseTone = .Friendly
    let speechSynthesizer = NSSpeechSynthesizer()
    let APIKey = ""
    
    func analyzeWriting() {
        self.isLoading = true
        let customPrompt = "Can you respond to the following email? Respond in a \(selectedResponseStyle.rawValue) style, \(selectedResponseLength.rawValue) length, but \(selectedResponseTone.rawValue) tone. Here is the email: \(writing)"
        print(customPrompt)
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(APIKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "gpt-4",
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
        withAnimation {
            self.showCheckmark = true
        }
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            showingModal = true
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
    }
    
    func speakText(_ text: String) {
        speechSynthesizer.startSpeaking(text)
    }
}

