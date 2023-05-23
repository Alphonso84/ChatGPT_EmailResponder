//
//  ContentEditorView.swift
//  EmailResponder
//
//  Created by Alphonso Sensley II on 5/13/23.
//

import Cocoa
import SwiftUI

struct ContentEditorView: View {
    @ObservedObject var viewModel = ContentEditorView_ViewModel()
    
    var body: some View {
        HStack {
            Picker("Response Tone", selection: $viewModel.selectedResponseTone) {
                ForEach(ResponseTone.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)
            .pickerStyle(MenuPickerStyle())
            .padding(.top)
            Picker("Response Style", selection: $viewModel.selectedResponseStyle) {
                ForEach(ResponseStyle.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)
            .pickerStyle(MenuPickerStyle())
            .padding(.top)
            Picker("Response Length", selection: $viewModel.selectedResponseLength) {
                ForEach(ResponseLength.allCases, id: \.self) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            .frame(width: 200)
            .pickerStyle(MenuPickerStyle())
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
                    viewModel.analyzeWriting()
                }) {
                    Text("Compose a Response")
                }
                .padding()
            }
            VStack {
                Text("\(viewModel.selectedResponseTone.rawValue), \(viewModel.selectedResponseStyle.rawValue), \(viewModel.selectedResponseLength.rawValue) email response:")
                    .padding()
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    Button(action: viewModel.copyToClipboard) {
                        Text("Copy Email Response to Clipboard")
                    }
                    .padding()
                }
            }
            
            .onAppear(perform: viewModel.checkFirstLaunch)
            .sheet(isPresented: $viewModel.showingModal) {
                ModalView(showingModal: viewModel.showingModal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentEditorView()
    }
}
