//
//  StatsAndSettingsView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/19/24.
//

import SwiftUI
import SwiftData

struct StatsAndSettingsView: View {
    @Query private var games: [Game]
    @State private var highScore: Int = 0
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                //Highest Score so Far
                Text("High Score")
                    .font(.largeTitle)
                Text("\(highScore)")
                    .font(.title)
            }
            .padding()
            
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            //Picker for user preference on color mode
            Picker("Mode", selection: $isDarkMode) {
                Text("Light").tag(false)
                Text("Dark").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Open App Settings") { //Button to open App Settings
                openAppSettings()
            }
        }
        .padding()
        .onAppear() {
            updateStats()
        }
    }
    
    
    private func openAppSettings() {
       guard let appSettings = URL(string: UIApplication.openSettingsURLString),
             UIApplication.shared.canOpenURL(appSettings) else {
           return
       }
       UIApplication.shared.open(appSettings)
    }
    
    private func updateStats() {
        highScore = games.getHighScore()
    }
}

//Extension to return the highest score scored by user
extension Array where Element == Game { //Where element:game conforms to game
    func getHighScore() -> Int {
        if self.isEmpty {
            return 0
        }
        let highestScoringGame = self.max(by: { $0.score < $1.score })
        return highestScoringGame?.score ?? 0
    }
}

#Preview {
    StatsAndSettingsView()
}
