//
//  CustomTextEditor.swift
//  SwiftyHelper
//
//  Created by Alphonso Sensley II on 5/22/23.
//

import SwiftUI
import AppKit


struct CustomTextEditorView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.font = NSFont(name: "Menlo", size: 20)
        textView.isEditable = true
        textView.isSelectable = true
        textView.backgroundColor = NSColor.black
        //textView.placeholder = "Enter Email Here"
        textView.textColor = NSColor.white
        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        nsView.string = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: CustomTextEditorView

        init(_ parent: CustomTextEditorView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}

extension NSTextView {
    @objc var placeholder: String {
        get {
            return ""
        }
        set {
            let placeholderString = NSAttributedString(string: newValue, attributes: [NSAttributedString.Key.foregroundColor: NSColor.gray])
            self.textStorage?.append(placeholderString)
        }
    }
}
