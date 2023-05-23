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
            PickerComponent(title: "Response Tone", selection: $viewModel.selectedResponseTone)
            PickerComponent(title: "Response Style", selection: $viewModel.selectedResponseStyle)
            PickerComponent(title: "Response Length", selection: $viewModel.selectedResponseLength)
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
