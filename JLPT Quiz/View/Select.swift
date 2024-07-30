//
//  Select.swift
//  JLPT Quiz
//
//  Created by Jeamin on 10/9/23.
//

import SwiftUI

struct Select: View {
    @State private var showJLPTN1: Bool = false
    @State private var showJLPTN2: Bool = false
    @State private var showJLPTN3: Bool = false
    @State private var showJLPTN4: Bool = false
    @State private var showJLPTN5: Bool = false    

    
    var body: some View {
        VStack {
            // JLPTN1 Button
            Button(action: {
                showJLPTN1.toggle()
            }) {
                Image("JLPTN1image")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN1) {
                JLPTN1(onFinish: {
                    showJLPTN1 = false
                })
            }
            
            // JLPTN2 Button
            Button(action: {
                showJLPTN2.toggle()
            }) {
                Image("JLPTN2image")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN2) {
                JLPTN2(onFinish: {
                    showJLPTN2 = false
                })
            }
            
            // JLPTN3 Button
            Button(action: {
                showJLPTN3.toggle()
            }) {
                Image("JLPTN3image")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN3) {
                JLPTN3(onFinish: {
                    showJLPTN3 = false
                })
            }
            
            // JLPTN4 Button
            Button(action: {
                showJLPTN4.toggle()
            }) {
                Image("JLPTN4image")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN4) {
                JLPTN4(onFinish: {
                    showJLPTN4 = false
                })
            }
            
            // JLPTN5 Button
            Button(action: {
                showJLPTN5.toggle()
            }) {
                Image("JLPTN5image")
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            }
            .fullScreenCover(isPresented: $showJLPTN5) {
                JLPTN5(onFinish: {
                    showJLPTN5 = false
                })
            }
            
        }
        .padding()
    }
}
