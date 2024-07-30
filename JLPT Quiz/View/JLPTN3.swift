//
//  JLPTN3.swift
//  JLPT Quiz
//
//  Created by Jeamin on 10/8/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation
import SDWebImageSwiftUI
import FirebaseStorage

struct JLPTN3: View {
    @State private var questions: [Question] = []
    @State private var startQuiz: Bool = false
    @AppStorage("log_status") private var logStatus: Bool = false
    var onFinish: () -> ()
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
    @State private var fontSizeChange: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var progressString: String = "0%"

    // 이미지 크기 조정을 위한 상태 변수
    @State private var imageWidth: CGFloat = 300
    @State private var imageHeight: CGFloat = 300

    var body: some View {
        VStack(spacing: 10) {
            dismissButton
            quizTitle
            progressBar
            questionViewer
            nextButton
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background(Color.white.ignoresSafeArea())
        .environment(\.colorScheme, .dark)
        .fullScreenCover(isPresented: $showScoreCard) {
            ScoreCardView(score: score / CGFloat(questions.count) * 100) {
                dismiss()
                onFinish()
            }
        }
        .task {
            do {
                try await fetchData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // UI 구성 요소
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.red)
        }
        .hAlign(.leading)
    }

    private var quizTitle: some View {
        Text("N3 文字、語彙、文法、読解")
            .font(.title)
            .fontWeight(.semibold)
            .hAlign(.leading)
            .foregroundColor(.black)
    }

    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                Rectangle()
                    .fill(Color.green)
                    .frame(width: progress * geometry.size.width, alignment: .leading)
                Text(progressString)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .clipShape(Capsule())
        }
        .frame(height: 20)
        .padding(.top, 6)
    }

    private var questionViewer: some View {
        GeometryReader { geometry in
            ForEach(questions.indices, id: \.self) { index in
                if currentIndex == index {
                    QuestionView(
                        question: questions[currentIndex],
                        fontSizeChange: $fontSizeChange,
                        scale: .constant(1.0),
                        currentIndex: $currentIndex,
                        questions: $questions,
                        score: $score,
                        imageWidth: $imageWidth,
                        imageHeight: $imageHeight
                    )
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
        .padding(.horizontal, -15)
        .padding(.vertical, 15)
    }

    private var nextButton: some View {
        CustomButton(title: currentIndex == (questions.count - 1) ? "끝" : "다음 문제") {
            if currentIndex == (questions.count - 1) {
                showScoreCard.toggle()
            } else {
                withAnimation(.easeInOut) {
                    currentIndex += 1
                    progress = CGFloat(currentIndex) / CGFloat(questions.count - 1)
                    progressString = String(format: "%.0f%%", progress * 100)
                }
            }
        }
    }

    // 데이터 가져오기
    func fetchData() async throws {
        try await loginUserAnonymous()
        
        let firestore = Firestore.firestore()
        let storage = Storage.storage()
        
        var questions = try await firestore.collection("Quiz").document("Info").collection("Questions2").getDocuments().documents.compactMap {
            try $0.data(as: Question.self)
        }
        
        for index in questions.indices {
            if let gsPath = questions[index].imageURL {
                let storageRef = storage.reference(forURL: gsPath)
                do {
                    let downloadURL = try await storageRef.downloadURL()
                    questions[index].imageURL = downloadURL.absoluteString
                } catch {
                    print("Error getting download URL for image at path \(gsPath): \(error.localizedDescription)")
                }
            }
        }
        
        questions.shuffle()
        
        let shuffledQuestions = questions
        
        await MainActor.run {
            self.questions = shuffledQuestions
        }
    }

    func loginUserAnonymous() async throws {
        if !logStatus {
            try await Auth.auth().signInAnonymously()
        }
    }
}

@ViewBuilder
func QuestionView2(
    question: Question,
    fontSizeChange: Binding<CGFloat>,
    scale: Binding<CGFloat>,
    currentIndex: Binding<Int>,
    questions: Binding<[Question]>,
    score: Binding<CGFloat>,
    imageWidth: Binding<CGFloat>,
    imageHeight: Binding<CGFloat>
) -> some View {
    ScrollView {
        VStack(alignment: .leading, spacing: 15) {
            Text("Question \(currentIndex.wrappedValue + 1)/\(questions.wrappedValue.count)")
                .font(.callout)
                .foregroundColor(.gray)
                .hAlign(.leading)
            
            SelectableTextView(text: question.question.replacingOccurrences(of: "\\n", with: "\n"), fontSizeChange: fontSizeChange)
                .frame(height: 200 * scale.wrappedValue)

            if let imageURL = question.imageURL, let url = URL(string: imageURL) {
                GeometryReader { geometry in
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .foregroundColor(.clear) // 투명한 배경
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(width: imageWidth.wrappedValue, height: imageHeight.wrappedValue)
                                .clipped()
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            let newWidth = min(max(100, imageWidth.wrappedValue + value.translation.width), geometry.size.width - 30)
                                            let newHeight = min(max(100, imageHeight.wrappedValue + value.translation.height), geometry.size.height - 30)
                                            imageWidth.wrappedValue = newWidth
                                            imageHeight.wrappedValue = newHeight
                                        }
                                )
                        case .failure:
                            Rectangle()
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: geometry.size.width - 30) // 이미지의 폭을 설정합니다.
                    .padding(.vertical, 10) // 이미지와 다른 요소 사이의 간격을 설정합니다.
                }
                .frame(height: 300) // `GeometryReader`의 높이를 고정합니다.
            }

            VStack(spacing: 12) {
                ForEach(question.options, id: \.self) { option in
                    ZStack {
                        OptionView(option, question.answer == option && question.tappedAnswer != "" ? Color.green : Color.black, scale: scale)
                        
                        if question.tappedAnswer == option && question.tappedAnswer != question.answer {
                            OptionView(option, Color.red, scale: scale)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        guard questions.wrappedValue[currentIndex.wrappedValue].tappedAnswer == "" else { return }
                        withAnimation(.easeInOut) {
                            questions.wrappedValue[currentIndex.wrappedValue].tappedAnswer = option
                            
                            if question.answer == option {
                                score.wrappedValue += 1.0
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 10)
        }
        .padding(15)
        .hAlign(.center)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.6))
        }
        .padding(.horizontal, 15)
    }
}


@ViewBuilder
func OptionView2(
    _ option: String,
    _ tint: Color,
    scale: Binding<CGFloat>
) -> some View {
    Text(option)
        .fixedSize(horizontal: false, vertical: true)
        .font(.system(size: 25 + scale.wrappedValue))
        .foregroundColor(tint)
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
        .hAlign(.center)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint.opacity(0.15))
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(tint.opacity(tint == .gray ? 0.15 : 1), lineWidth: 2)
                }
        }
}

#Preview {
    ContentView()
}
