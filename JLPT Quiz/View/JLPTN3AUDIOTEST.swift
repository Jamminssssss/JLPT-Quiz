//
//  JLPTN3AUDIOTEST.swift
//  JLPT Quiz
//
//  Created by Jeamin on 11/18/23.
//

import SwiftUI
import AVFoundation

struct JLPTN3AUDIOTEST: View {
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
            
            Text("N3 聴解")
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
                audioPlayer?.stop()

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
                AudioQuestion(options: ["アウ", "アエ", "イウ", "イエ"], answer: "アエ", audioFile: "N3Q1", startTime: 0, endTime: 65, images: ["Image1"]),
                AudioQuestion(options: ["水曜日", "木曜日", "金曜日", "土曜日"], answer: "金曜日", audioFile: "N3Q2", startTime: 0, endTime: 64),
                AudioQuestion(options: ["さんかしゃを かくにんする", "店に電話する", "メールをかくにんする", "ないようを決める"], answer: "さんかしゃを かくにんする", audioFile: "N3Q3", startTime: 0, endTime: 73),
                AudioQuestion(options: ["セミナーにもうしこむ", "テストをうける", "けいじばんを見る", "さんかひをふりこむ"], answer: "テストをうける", audioFile: "N3Q4", startTime: 0, endTime: 66),
                AudioQuestion(options: ["ちょうさけっかを入力する", "サンプルをしてんに送る", "かいぎのじゅんびをする", "大野さんに仕事をたのむ"], answer: "ちょうさけっかを入力する", audioFile: "N3Q5", startTime: 0, endTime: 76),
                AudioQuestion(options: ["たいそう教室にもうしこむ", "DVD を買う", "びょういんに行く", "スポーツクラブに行く"], answer: "DVD を買う", audioFile: "N3Q6", startTime: 0, endTime: 84),
                AudioQuestion(options: ["気に入ったのがなかったから", "今すぐ買うひつようが なくなったから", "ねだんが高かったから", "おっとといっしょに えらびたかったから"], answer: "今すぐ買うひつようが なくなったから", audioFile: "N3Q7", startTime: 0, endTime: 88),
                AudioQuestion(options: ["年をとってからの生活のため", "家を買うため", "海外旅行をするため", "りゅうがくするため"], answer: "りゅうがくするため", audioFile: "N3Q8", startTime: 0, endTime: 97),
                AudioQuestion(options: ["ペットをびょういんにつれて行くから", "母がけがをしたから", "アルバイトに行くから", "クラブの話し合いがあるから"], answer: "ペットをびょういんにつれて行くから", audioFile: "N3Q9", startTime: 0, endTime: 81),
                AudioQuestion(options: ["サラさんの友人に教えてもらう", "テレビを見て自分で勉強する", "インターネットでレッスンをうける", "外国語の学校に通う"], answer: "サラさんの友人に教えてもらう", audioFile: "N3Q10", startTime: 0, endTime: 127),
                AudioQuestion(options: ["朝食のメニューが売れていない", "近所の人があまり来てくれない", "こんでいてもせきを空けないきゃくがいる", "ことばづかいがよくない店員がいる"], answer: "こんでいてもせきを空けないきゃくがいる", audioFile: "N3Q11", startTime: 0, endTime: 104),
                AudioQuestion(options: ["せんぱいにしりょうを見せる", "ちょうさをしなおす", "しりょうにグラフをくわえる", "はっぴょうのながれを かえる"], answer: "はっぴょうのながれを かえる", audioFile: "N3Q12", startTime: 0, endTime: 107),
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
