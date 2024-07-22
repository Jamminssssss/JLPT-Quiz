//
//  JLPTN1AUDIOTEST.swift
//  JLPT Quiz
//
//  Created by Jeamin on 11/14/23.
//

import SwiftUI
import AVFoundation

struct JLPTN1AUDIOTEST: View {
    @State private var questions: [AudioQuestion] = []
    @State private var currentIndex: Int = 0
    @State private var score: CGFloat = 0
    @State private var showScoreCard: Bool = false
    @State private var progress: CGFloat = 0
    @State private var progressString: String = "0%"
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var tappedAnswer: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var onFinish: () -> ()
    
    var body: some View {
        VStack(spacing: 10) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            .hAlign(.leading)
            
            Text("N1 聴解")
                .font(.title)
                .fontWeight(.semibold)
                .hAlign(.leading)
                .foregroundColor(.black)
            
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
            .padding(.top, 5)
            
            if !questions.isEmpty, questions.indices.contains(currentIndex) {
                QuestionView(audioQuestion: questions[currentIndex], tappedAnswer: $tappedAnswer) { option in
                    guard tappedAnswer == "" else { return }
                    withAnimation(.easeInOut) {
                        tappedAnswer = option
                        
                        if questions[currentIndex].answer == option {
                            score += 1.0
                        }
                    }
                }
                .padding(.horizontal, -15)
                .padding(.vertical, 15)
            }
            
            CustomButton(title: currentIndex == (questions.count - 1) ? "끝" : "다음 문제") {
                // Stop the audio

                if currentIndex == (questions.count - 1) {
                    showScoreCard.toggle()
                } else {
                    withAnimation(.easeInOut) {
                        currentIndex += 1
                        progress = CGFloat(currentIndex) / CGFloat(questions.count - 1)
                        progressString = String(format: "%.0f%%", progress * 100)
                        tappedAnswer = "" // Reset the selected answer
                    }
                }
            }
           
        }
        .padding(15)
        .hAlign(.center)
        .vAlign(.top)
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
        .fullScreenCover(isPresented: $showScoreCard) {
            // ScoreCardView code goes here
            ScoreCardView(score: score / CGFloat(questions.count) * 100) {
                dismiss()
                onFinish()
            }
               
        }
        .onAppear {
            questions = [
                AudioQuestion(options: ["商品を補充する", "さくら店に商品を送る", "ダイレクトメールの発送の準備をする", "店で使用するかざりを作る"], answer: "商品を補充する", audioFile: "N1Q1" ,startTime: 0, endTime: 70),
                AudioQuestion(options: ["体験者のビデオを見る", "先生にすいせんじょうを依頼する", "保険の加入手続きをする", "指定科目の成績をかくにんする"], answer: "指定科目の成績をかくにんする", audioFile: "N1Q2",startTime: 0, endTime: 87),
                AudioQuestion(options: ["見積もりの合計金額を見直す", "見積もり金額の内訳を詳しく書く", "バスが確保できたかかくにんする", "見積書の有効期限を書く"], answer: "見積もり金額の内訳を詳しく書く", audioFile: "N1Q3",startTime: 0, endTime: 86),
                AudioQuestion(options: ["企画書を修正する", "出張の資料を作成する", "店の予約をキャンセルする", "会食に使う店を探す"], answer: "企画書を修正する", audioFile: "N1Q4",startTime: 0, endTime: 88),
                AudioQuestion(options: ["研修期間を長くする", "店の経営理念を伝える", "時給を上げる", "業務のしゅうじゅくどを評価する"], answer: "店の経営理念を伝える", audioFile: "N1Q5",startTime: 0, endTime: 114),
                AudioQuestion(options: ["投書らんを設ける", "政策関連の記事に図を用いる", "イベント情報の記事を増やす", "子育て関連の記事を増やす"], answer: "政策関連の記事に図を用いる", audioFile: "N1Q6",startTime: 0, endTime: 105),
                AudioQuestion(options: ["料理が冷めにくいから", "丈夫で長持ちするから", "安くて見た目がはなやかだから", "いろいろな調理に使えるから"], answer: "丈夫で長持ちするから", audioFile: "N1Q7",startTime: 0, endTime: 117),
                AudioQuestion(options: ["上司が応募を 快く思わないこと", "新しい部署に採用される可能性が低いこと", "商品開発の仕事の経験がないこと", "不採用だったら今の部署にいづらくなること"], answer: "不採用だったら今の部署にいづらくなること", audioFile: "N1Q8",startTime: 0, endTime: 113),
                AudioQuestion(options: ["ほかの学校に転校したこと", "友達が迎えに来てくれたこと", "先生が相談に乗ってくれたこと", "同じ経験をもつ人と話せたこと"], answer: "友達が迎えに来てくれたこと", audioFile: "N1Q9",startTime: 0, endTime: 123),
                AudioQuestion(options: ["世界初のロボットの誕生", "ロボットの定義づけ", "ロボットの社会的使命", "ロボット製作に必要な情報処理"], answer: "世界初のロボットの誕生", audioFile: "N1Q10",startTime: 0, endTime: 94),
                AudioQuestion(options: ["集落のいせきとして国内最古のものであること", "国内のいせきの中で規模が最も大きいこと", "高度な技術で作った道具が見つかったこと", "食料として作物を育てていたことがわかったこと"], answer: "食料として作物を育てていたことがわかったこと", audioFile: "N1Q11",startTime: 0, endTime: 97),
                AudioQuestion(options: ["安全性を確保した通学路にすること", "防犯のために街灯の数を増やすこと", "住民が交流できる施設を建てること", "災害時の避難場所を作ること"], answer: "安全性を確保した通学路にすること", audioFile: "N1Q12",startTime: 0, endTime: 124),
                AudioQuestion(options: ["政治に関心をもたない人が増えたから", "候補者間の主張の違いが不明確だったから", "現職の知事の勝利が確実だったから", "投票の時期が年末で忙しい人が多かったから"], answer: "候補者間の主張の違いが不明確だったから", audioFile: "N1Q13",startTime: 0, endTime: 104)
            ]
        }
    }
    
    
    struct PlayButtonView: View {
            var audioQuestion: AudioQuestion
            @Binding var isPlaying: Bool
            @Binding var audioPlayer: AVAudioPlayer?
            
            var body: some View {
                HStack {
                    Button(action: {
                        toggleAudio(audioQuestion: audioQuestion)
                    }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        restartAudio(audioQuestion: audioQuestion)
                    }) {
                        Image(systemName: "gobackward")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                    }
                }
                .onChange(of: audioQuestion.audioFile) { _ in
                           // 오디오 파일이 변경될 때(예: 다음 문제로 이동할 때) 오디오를 중지합니다.
                           stopAudio()
                       }
                .onDisappear {
                    // Stop the audio when the view disappears (e.g., app exits)
                    stopAudio()
                }
            }
            
            func toggleAudio(audioQuestion: AudioQuestion) {
                print("Toggling audio")
                if isPlaying {
                    audioPlayer?.pause()
                    print("Audio paused.")
                } else {
                    if audioPlayer == nil {
                        // If audio player is nil, create and play the audio
                        playAudio(audioQuestion: audioQuestion)
                    } else {
                        // If audio player exists, resume playing
                        audioPlayer?.play()
                    }
                    print("Audio played.")
                }
                isPlaying.toggle()
            }
            func playAudio(audioQuestion: AudioQuestion) {
                stopAudio()
                
                if let url = Bundle.main.url(forResource: audioQuestion.audioFile, withExtension: "mp3") {
                    print("Playing audio from URL: \(url)")
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.currentTime = audioQuestion.startTime // Add this line
                        audioPlayer?.play()
                        
                        // Schedule a timer to stop audio at the end time
                        let endTime = audioQuestion.endTime
                        Timer.scheduledTimer(withTimeInterval: endTime - audioQuestion.startTime, repeats: false) { _ in
                            stopAudio()
                            isPlaying = false
                        }
                    } catch {
                        print("Error creating AVAudioPlayer: \(error)")
                    }
                } else {
                    print("Audio file not found.")
                }
            }
            
            func restartAudio(audioQuestion: AudioQuestion) {
                audioPlayer?.currentTime = audioQuestion.startTime
                audioPlayer?.play()
                isPlaying = true
            }
            
            func stopAudio() {
                audioPlayer?.stop()
                audioPlayer = nil
                isPlaying = false
            }
        }
        
        struct QuestionView: View {
                var audioQuestion: AudioQuestion
                @Binding var tappedAnswer: String
                var onTap: (String) -> Void
                @State var isPlaying: Bool = false
                @State var audioPlayer: AVAudioPlayer?

                var body: some View {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(audioQuestion.images ?? [], id: \.self) { imageName in
                                               Image(imageName)
                                                   .resizable()
                                                   .aspectRatio(contentMode: .fit)
                                            
                                           }

                            HStack {
                                Spacer()
                                PlayButtonView(audioQuestion: audioQuestion, isPlaying: $isPlaying, audioPlayer: $audioPlayer)
                                Spacer()
                            }

                            ForEach(audioQuestion.options, id: \.self) { option in
                                ZStack {
                                    OptionView(option: option, tint: audioQuestion.answer == option && tappedAnswer != "" ? Color.green : Color.black)

                                    if tappedAnswer == option && tappedAnswer != audioQuestion.answer {
                                        OptionView(option: option, tint: Color.red)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    onTap(option)
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

        
        struct OptionView: View {
            var option: String
            var tint: Color
            
            var body: some View {
                Text(option)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.title)
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
        }
    }
