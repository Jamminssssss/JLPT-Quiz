//
//  SelectAudioTest.swift
//  JLPT Quiz
//
//  Created by Jeamin on 11/14/23.
//

import SwiftUI

struct SelectAudioTest: View {
    @State private var showJLPTN1AUDIOTEST: Bool = false
    @State private var showJLPTN2AUDIOTEST: Bool = false
    @State private var showJLPTN3AUDIOTEST: Bool = false
    @State private var showJLPTN4AUDIOTEST: Bool = false
    @State private var showJLPTN5AUDIOTEST: Bool = false

    var body: some View {
        VStack {
            Button(action: {
                showJLPTN1AUDIOTEST.toggle()
            }) {
                Image("JLPTN1AUDIOTESTimage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN1AUDIOTEST) {
                JLPTN1AUDIOTEST(onFinish: {
                    showJLPTN1AUDIOTEST = false
                })
            }
            Button(action: {
                showJLPTN2AUDIOTEST.toggle()
            }) {
                Image("JLPTN2AUDIOTESTimage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN2AUDIOTEST) {
                JLPTN2AUDIOTEST(onFinish: {
                    showJLPTN2AUDIOTEST = false
                })
            }
            Button(action: {
                showJLPTN3AUDIOTEST.toggle()
            }) {
                Image("JLPTN3AUDIOTESTimage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN3AUDIOTEST) {
                JLPTN3AUDIOTEST(onFinish: {
                    showJLPTN3AUDIOTEST = false
                })
            }
            Button(action: {
                showJLPTN4AUDIOTEST.toggle()
            }) {
                Image("JLPTN4AUDIOTESTimage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN4AUDIOTEST) {
                JLPTN4AUDIOTEST(onFinish: {
                    showJLPTN4AUDIOTEST = false
                })
            }
            Button(action: {
                showJLPTN5AUDIOTEST.toggle()
            }) {
                Image("JLPTN5AUDIOTESTimage")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN5AUDIOTEST) {
                JLPTN5AUDIOTEST(onFinish: {
                    showJLPTN5AUDIOTEST = false
                })
            }
        }
        .padding()
    }
}

