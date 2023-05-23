//
//  ContentEditorView.swift
//  EmailResponder
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import Cocoa
import SwiftUI


//TODO: Now that proof of concept is complete. Start code cleanup, create proper model. Better seperate responsibility by utilizing MVVM to help reduce amount of code in this class.

struct ContentEditorView: View {
    @ObservedObject var viewModel = ContentEditorView_ViewModel()

    
    var body: some View {
        HStack {
            Picker("Response Tone", selection: $viewModel.selectedResponseTone) {
                ForEach(ResponseTone.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)  // Adjust the width as needed
            .pickerStyle(MenuPickerStyle())  // Use menu style for macOS app
            .padding(.top)
            Picker("Response Style", selection: $viewModel.selectedResponseStyle) {
                ForEach(ResponseStyle.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)  // Adjust the width as needed
            .pickerStyle(MenuPickerStyle())  // Use menu style for macOS app
            .padding(.top)
            Picker("Response Length", selection: $viewModel.selectedResponseLength) {
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
                
                CustomTextEditorView(text: $viewModel.writing)
                    .font(.custom("Menlo", size: 20))
                    .border(Color.black, width: 1)
                    .padding(.leading)
                    .padding(.trailing)
                    
                
                Button(action: {
                    analyzeWriting(viewModel.writing)
                }) {
                    Text("Compose a Response")
                }
                .padding()
            }
            
            VStack {
                Text("\(viewModel.selectedResponseTone.rawValue), \(viewModel.selectedResponseStyle.rawValue), \(viewModel.selectedResponseLength.rawValue) email response:")
                    .padding()
                if viewModel.isLoading {
                    ProgressView() // Shows a loading spinner
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the spinner
                } else {
                    ZStack{
                        TypingView(fullText:viewModel.analysis)
                            .frame(maxWidth:.infinity,maxHeight: .infinity)
                            .font(.custom("Menlo", size: 20))
                            .border(Color.black, width: 1)
                            .padding(.leading)
                            .padding(.trailing)
                        if viewModel.showCheckmark {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.green)
                                .opacity(viewModel.showCheckmark ? 1 : 0)
                                .animation(.easeInOut(duration: 2))
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            viewModel.showCheckmark = false
                                        }
                                    }
                                }
                        }
                    }
                    Button(action: copyToClipboard) {
                        Text("Copy Email Response to Clipboard")
                    }
                    .padding()
                }
            }
            
            .onAppear(perform: checkFirstLaunch)
            .sheet(isPresented: $viewModel.showingModal) {
                ModalView(showingModal: viewModel.showingModal)
            }
        }
    }
    
    func analyzeWriting(_ writing: String) {
        viewModel.isLoading = true
        let customPrompt = "Can you respond to the following email? Respond in a \(viewModel.selectedResponseStyle.rawValue) style, \(viewModel.selectedResponseLength.rawValue) length, but \(viewModel.selectedResponseTone.rawValue) tone. Here is the email: \(writing)"
        print(customPrompt)
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(viewModel.APIKey)", forHTTPHeaderField: "Authorization")
        
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
                            self.viewModel.isLoading = false
                            self.viewModel.analysis = content
                            self.viewModel.speakText(content)
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
        pasteboard.setString(viewModel.analysis, forType: .string)
        withAnimation {
            self.viewModel.showCheckmark = true
        }
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if !isFirstLaunch {
            viewModel.showingModal = true
            UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        }
    }
    
    func speakText(_ text: String) {
        viewModel.speechSynthesizer.startSpeaking(text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentEditorView()
    }
}
