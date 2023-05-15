//
//  ContentView.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import Cocoa
import SwiftUI
import Highlightr

enum ResponseLength:String, CaseIterable {
    case VeryShort = "very short"
    case Short = "short"
    case Medium = "medium"
    case Similar = "similar"
    case Long = "long"
}

enum ResponseTone:String, CaseIterable {
    case Direct = "direct"
    case Friendly = "friendly"
    case Serious = "serious"
    case Excited = "excited"
    case Sad = "sad"
    case Cheerful = "cheerful"
    case Rude = "rude"
    case Humorous = "humorous"
}

enum ResponseStyle: String, CaseIterable  {
    case Professional = "professional"
    case Formal = "formal"
    case Relaxed = "relaxed"
    case InFormal = "informal"
    case Familiar = "familiar"
    case OldEnglish = "old english"
    case Childish = "childish"
    case YoungCali = "young californian"
    case SouthernBelle = "southern belle"
    case Ebonics = "ebonics"
}

struct ContentView: View {
    private let speechSynthesizer = NSSpeechSynthesizer()
    let APIKey = ""
    @State private var writing = ""
    @State private var analysis = ""
    @State private var showingModal = false
    @State private var isLoading = false
    @State private var selectedResponseStyle: ResponseStyle = .Professional
    @State private var selectedResponseLength: ResponseLength = .Short
    @State private var selectedResponseTone: ResponseTone = .Friendly
    
    
    var body: some View {
        HStack {
            Picker("Response Tone", selection: $selectedResponseTone) {
                ForEach(ResponseTone.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)  // Adjust the width as needed
            .pickerStyle(MenuPickerStyle())  // Use menu style for macOS app
            .padding(.top)
            Picker("Response Style", selection: $selectedResponseStyle) {
                ForEach(ResponseStyle.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)  // Adjust the width as needed
            .pickerStyle(MenuPickerStyle())  // Use menu style for macOS app
            .padding(.top)
            Picker("Response Length", selection: $selectedResponseLength) {
                ForEach(ResponseLength.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)  // Adjust the width as needed
            .pickerStyle(MenuPickerStyle())  // Use menu style for macOS app
            .padding(.top)
        }
        HSplitView {
            VStack {
                Text("Paste your email below:")
                    .padding()
                
                TextEditor(text: $writing)
                    .font(.custom("Menlo", size: 20))
                    .border(Color.black, width: 1)
                    .padding(.leading)
                    .padding(.trailing)
                
                Button(action: {
                    analyzeWriting(writing)
                }) {
                    Text("Compose a Response")
                }
                .padding()
            }
            
            VStack {
                Text("\(selectedResponseTone.rawValue), \(selectedResponseStyle.rawValue), \(selectedResponseLength.rawValue) email response:")
                    .padding()
                if isLoading {
                    ProgressView() // Shows a loading spinner
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the spinner
                } else {
                    TextEditor(text: $analysis)
                        .disabled(true)
                        .font(.custom("Menlo", size: 20))
                        .border(Color.black, width: 1)
                        .padding(.leading)
                        .padding(.trailing)
                    Button(action: copyToClipboard) {
                        Text("Copy Analysis to Clipboard")
                    }
                    .padding()
                }
            }
        }
        
        .onAppear(perform: checkFirstLaunch)
        .sheet(isPresented: $showingModal) {
            ModalView(showingModal: showingModal)
        }
    }
    
    func analyzeWriting(_ writing: String) {
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
