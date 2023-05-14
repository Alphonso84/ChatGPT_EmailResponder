import SwiftUI
import Highlightr

struct HighlightingTextView: NSViewRepresentable {
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextView {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "Chalk")
       

        let textView = NSTextView()
        textView.delegate = context.coordinator
        textView.string = text
        textView.backgroundColor = NSColor.clear
        textView.isEditable = true
        textView.isSelectable = true
        textView.textStorage?.setAttributedString(highlightr?.highlight(text, as: "swift", fastRender: true) ?? NSAttributedString(string: ""))
        

        return textView
    }

    func updateNSView(_ nsView: NSTextView, context: Context) {
        let highlightr = Highlightr()
        highlightr?.setTheme(to: "dracula")
        nsView.textStorage?.setAttributedString(highlightr?.highlight(text, as: "swift", fastRender: true) ?? NSAttributedString(string: ""))
        nsView.backgroundColor = NSColor.windowBackgroundColor
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: HighlightingTextView

        init(_ parent: HighlightingTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.text = textView.string
        }
    }
}

