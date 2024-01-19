//
//  ContentView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: { selectedTab = 0 }) {
                        Text("Scores")
                            .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    }
                    Spacer() //Spacers in between the buttons
                    Button(action: { selectedTab = 1 }) {
                        Text("New Game")
                            .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    }
                    Spacer()
                    Button(action: { selectedTab = 2 }) {
                        Text("Settings")
                            .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    }
                }
                .padding(.bottom, 5)
                .padding(.horizontal)

                switch selectedTab { //Here's a switch for the selectedTab Variable
                case 0: //If 0, show scores
                    PreviousGamesView()
                case 1: //If 1, start a new game
                    GameView()
                default: //Otherwise show the settings
                    StatsAndSettingsView()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}

