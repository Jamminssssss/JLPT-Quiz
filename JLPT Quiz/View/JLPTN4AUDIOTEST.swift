//
//  JLPTN4AUDIOTEST.swift
//  JLPT Quiz
//
//  Created by Jeamin on 11/18/23.
//

import SwiftUI
import AVFoundation

struct JLPTN4AUDIOTEST: View {
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
            
            Text("N4 聴解")
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
                AudioQuestion(options: ["アウ", "アエ", "イウ", "イエ"], answer: "アウ", audioFile: "N4Q1", startTime: 0, endTime: 64,images: ["Image2"]),
                AudioQuestion(options: ["1", "2", "3", "4"], answer: "3", audioFile: "N4Q2", startTime: 0, endTime: 62,images: ["Image3"]),
                AudioQuestion(options: ["1", "2", "3", "4"], answer: "2", audioFile: "N4Q3", startTime: 0, endTime: 63,images: ["Image4"]),
                AudioQuestion(options: ["アイウエ", "アイウ", "イウエ", "イウ"], answer: "イウ", audioFile: "N4Q4", startTime: 0, endTime: 56,images: ["Image5"]),
                AudioQuestion(options: ["1", "2", "3", "4"], answer: "3", audioFile: "N4Q5", startTime: 0, endTime: 64,images: ["Image6"]),
                AudioQuestion(options: ["1", "2", "3", "4"], answer: "3", audioFile: "N4Q6", startTime: 0, endTime: 64,images: ["Image7"]),
                AudioQuestion(options: ["えき前の ほんや", "大学の 中の ほんや", "じむしょ", "しょくどうの 前"], answer: "じむしょ", audioFile: "N4Q7", startTime: 0, endTime: 56),
                AudioQuestion(options: ["アイ", "アウ", "イウ", "イ"], answer: "アイ", audioFile: "N4Q8", startTime: 0, endTime: 64,images: ["Image8"]),
                AudioQuestion(options: ["うみの ちかくで しょくじした", "山に のぼった", "うみで およいだ", "かいがんを さんぽした"], answer: "うみの ちかくで しょくじした", audioFile: "N4Q9", startTime: 0, endTime: 94),
                AudioQuestion(options: ["ジュース", "アイスクリーム", "キャンディー", "クッキー"], answer: "アイスクリーム", audioFile: "N4Q10", startTime: 0, endTime: 83),
                AudioQuestion(options: ["山本さんが きょうしつに いるとき", "山本さんが きょうしつを 出たとき", "山本さんが としょかんに いるとき", "山本さんが としょかんを 出たとき"], answer: "山本さんが としょかんを 出たとき", audioFile: "N4Q11", startTime: 0, endTime: 100),
                AudioQuestion(options: ["あく 時間が はやく なる", "しまる 時間が おそく なる", "中学生いかは ただに なる", "チケットが 安く なる"], answer: "しまる 時間が おそく なる", audioFile: "N4Q12", startTime: 0, endTime: 95),
                AudioQuestion(options: ["いろいろな ばしょに おいて あること", "うって いる ものの しゅるいが 多いこと", "ことばを 話すこと", "お金が ぬすまれないこと"], answer: "うって いる ものの しゅるいが 多いこと", audioFile: "N4Q13", startTime: 0, endTime: 102),
                AudioQuestion(options: ["5時から 5時半まで", "5時から 6時まで", "5時半から 6時まで", "5時半から 6時半まで"], answer: "5時半から 6時半まで", audioFile: "N4Q14", startTime: 0, endTime: 81),
                AudioQuestion(options: ["食べものの 店が たくさん あるから", "まつりが あって にぎやかだから", "ふねの 上で さくらが 見られるから", "会社から あるいて 行けるから"], answer: "ふねの 上で さくらが 見られるから", audioFile: "N4Q15", startTime: 0, endTime: 101),
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
