//
//  SelectableTextView.swift
//  JLPT Quiz
//
//  Created by Jeamin on 7/19/24.
//

import SwiftUI

struct SelectableTextView: UIViewRepresentable {
    var text: String
    @Binding var fontSizeChange: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = UIFont.systemFont(ofSize: 25 + fontSizeChange)
        textView.backgroundColor = .clear
        textView.text = text
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont.systemFont(ofSize: 25 + fontSizeChange)
        uiView.textColor = .black // 텍스트 색상을 검정색으로 설정
    }
}
