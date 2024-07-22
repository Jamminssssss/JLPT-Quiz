//
//  ContentView.swift
//  JLPT Quiz
//
//  Created by Jeamin on 2023/10/07.
//
import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                Select()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "pencil.line")
                Text("文字、語彙、文法、読解")
            }
            .tag(0)
            
            NavigationView {
                SelectAudioTest()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "speaker.circle.fill")
                Text("聴解")
            }
            .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
