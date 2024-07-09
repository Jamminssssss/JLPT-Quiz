//
//  JLPTN4.swift
//  JLPT Quiz
//
//  Created by Jeamin on 10/8/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct JLPTN4: View {
    @State private var questions: [Question] = []
    @State private var startQuiz: Bool = false
    @AppStorage("log_status") private var logStatus: Bool = false
    var onFinish: ()->()
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
    @State private var fontSizeChange: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var progressString: String = "0%"

    var body: some View {
        VStack(spacing: 10){
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            .hAlign(.leading)
            
                Text("N4 文字、語彙、文法、読解")
                    .font(.title)
                    .fontWeight(.semibold)
                    .hAlign(.leading)
                    .foregroundColor(.black)

            GeometryReader{
                let size = $0.size
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.black.opacity(0.2))
                    
                    Rectangle()
                        .fill(Color(.green))
                        .frame(width: progress * size.width,alignment: .leading)
                    
                    Text(progressString)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .clipShape(Capsule())
            }
            .frame(height: 20)
            .padding(.top,6)
            
            GeometryReader{
                let _ = $0.size
                
                ForEach(questions.indices,id: \.self) { index in
                    if currentIndex == index{
                        QuestionView(question: questions[currentIndex])
                            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
            }
            .padding(.horizontal,-15)
            .padding(.vertical,15)
            
            CustomButton(title: currentIndex == (questions.count - 1) ? "끝" : "다음 문제") {
                if currentIndex == (questions.count - 1){
                    showScoreCard.toggle()
                }else{
                    withAnimation(.easeInOut){
                        currentIndex += 1
                        progress = CGFloat(currentIndex) / CGFloat(questions.count - 1)
                        progressString = String(format: "%.0f%%", progress * 100)
                    }
                }
            }
        }
        .padding(15)
        .hAlign(.center).vAlign(.top)
        .background {
            Color.purple
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
        .fullScreenCover(isPresented: $showScoreCard) {
            ScoreCardView(score: score / CGFloat(questions.count) * 100) {
                dismiss()
                onFinish()
            }
        }
        .task {
            do{
                try await fetchData()
            }catch{
                print(error.localizedDescription)
            }
        }
    }

    @ViewBuilder
    func QuestionView(question: Question)->some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Question \(currentIndex + 1)/\(questions.count)")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .hAlign(.leading)
                
                // 줄바꿈 문자를 사용하여 여러 줄의 텍스트를 표시합니다.
                Text(question.question.replacingOccurrences(of: "\\n", with: "\n"))
                    .font(.system(size: 25 + fontSizeChange))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
                VStack(spacing: 12){
                    ForEach(question.options,id: \.self){option in
                        ZStack{
                            OptionView(option, question.answer == option && question.tappedAnswer != "" ? Color.green : Color.black)
                            
                            if question.tappedAnswer == option && question.tappedAnswer != question.answer {
                                OptionView(option, Color.red)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard questions[currentIndex].tappedAnswer == "" else{return}
                            withAnimation(.easeInOut){
                                questions[currentIndex].tappedAnswer = option
                                
                                if question.answer == option{
                                    score += 1.0
                                }
                            }
                        }
                    }
                }
                .padding(.vertical,10)
            }
            .padding(15)
            .hAlign(.center)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.6))
            }
            .padding(.horizontal,15)
            .gesture(DragGesture().onEnded { value in
                let swipeDistance = value.translation.width / 10
                if swipeDistance > 0 {
                    // Increase font size when swiping right
                    fontSizeChange = min(swipeDistance, 10) // Limit maximum font size increase
                } else {
                    // Decrease font size when swiping left
                    fontSizeChange = max(swipeDistance, -10) // Limit maximum font size decrease
                }
            })
        }
    
    
    @ViewBuilder
    func OptionView(_ option: String,_ tint: Color)->some View{
        ScrollView {
            Text(option)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 25 + fontSizeChange))
                .foregroundColor(tint)
                .padding(.horizontal,5)
                .padding(.vertical,10)
                .hAlign(.center)
                .background {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(tint.opacity(0.15))
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(tint.opacity(tint == .gray ? 0.15 : 1),lineWidth: 2)
                        }
                }
        }
    }

    
    func fetchData() async throws {
        try await loginUserAnonymous()
        var questions = try await Firestore.firestore().collection("Quiz").document("Info").collection("Questions3").getDocuments().documents.compactMap{
            try $0.data(as: Question.self)
        }
        
        // Shuffle the questions
        questions.shuffle()
        
        // Make a copy of the shuffled questions
        let shuffledQuestions = questions
        
        await MainActor.run(body: {
            self.questions = shuffledQuestions
        })
    }
    
    func loginUserAnonymous() async throws {
        if !logStatus {
            try await Auth.auth().signInAnonymously()
        }
    }
}

#Preview {
    ContentView()
}
