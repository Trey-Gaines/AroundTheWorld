//
//  GameView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/17/24.
//

import SwiftUI
import Foundation

struct GameView: View {
    @Environment(\.modelContext) var modelContext
    @State private var newGame = GenerateCards()
    @State private var flippedCards: [String] = []
    @State private var matchMessage = ""
    @State private var score = 0
    @State private var isCheckingMatch = false
    @State private var lastFlipTime = Date()
    @State private var timePassed = 0
    @State private var startTime = Date()
    @State private var matchesMade = 0
    @State private var showAlert = false
    @State private var endMessage = "Good Game!"
    @State private var timer: Timer? = nil
    @State private var gameMatches: [String:String] = [:]
    
    let countryDict: [String: String] = ["🇺🇸":"United States of America",
                                         "🇰🇪":"Kenya", "🇨🇳":"China", "🇮🇳":"India",
                                         "🇮🇩":"Indonesia", "🇵🇰":"Pakistan",
                                         "🇧🇷":"Brazil", "🇳🇬":"Nigeria",
                                         "🇧🇩":"Bangladesh", "🇷🇺":"Russia",
                                         "🇲🇽":"Mexico", "🇯🇵":"Japan", "🇵🇭":"Philippines",
                                         "🇪🇬":"Egypt", "🇪🇹":"Ethiopia", "🇻🇳":"Vietnam",
                                         "🇮🇷":"Iran",  "🇹🇷":"Turkey", "🇩🇪":"Germany",
                                         "🇫🇷":"France",  "🇹🇭":"Thailand", "🇬🇧":"United Kingdom",
                                         "🇮🇹":"Italy", "🇿🇦":"South Africa", "🇰🇷":"South Korea",
                                         "🇪🇸":"Spain", "🇸🇩":"Sudan", "🇵🇱":"Poland",
                                         "🇨🇦":"Canada", "🇦🇺":"Australia", "🇸🇪":"Sweden",
                                         "🇩🇰":"Denmark", "🇸🇬":"Singapore", "🇫🇮":"Finland",
                                         "🇬🇷":"Greece", "🇳🇱":"Netherlands", "🇭🇺":"Hungary"]
    
    var body: some View {
            VStack {
                HStack {
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .bold()
                    Spacer() //Adds available space between the elements of the Horizontal Stack
                    VStack {
                        Text("Time:")
                            .font(.title3)
                            .bold()
                        Text("\(formatTime(timePassed))")
                            .font(.title3)
                            .bold()
                    }
                }
                HStack {
                    CardView(thisCard: newGame[0], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[1], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[2], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[3], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                }
               
                HStack {
                    CardView(thisCard: newGame[4], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[5], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[6], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[7], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                }
                
                HStack {
                    CardView(thisCard: newGame[8], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[9], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[10], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                    CardView(thisCard: newGame[11], flippedCards: $flippedCards, isCheckingMatch: $isCheckingMatch)
                }
                
                Text(matchMessage) //Match Message at the bottom to inform user of match
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .alert("Woah!", isPresented: $showAlert) {
                Button("Start New Game", action: restartGame)
                Button("I'm good", role: .cancel) {}
                } message: {
                    Text("You beat the game.")
            }
            .cornerRadius(3)
        
            .onAppear() {
                startTime = Date()
                
                //This will start a new Timer object with an interval to update/run the code inside every 1 section
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    let currentTime = Date() //Set a new CurrentTime Object
                    //Set timepassed as the INT conversion of the current time's interval since the start time (norm a double)
                    timePassed = Int(currentTime.timeIntervalSince(startTime))
                }
            }
        
            .onDisappear() {
                restartGame()
            }
        
            .onChange(of: flippedCards) {
                if flippedCards.count == 2 {
                    checkForMatch()
            }
        }
    }
    
    
    
    //Helper Functions
    
    
    
    //Check for a match between two flipped cards
    func checkForMatch() {
        //First ensure there are two cards to compare
        guard flippedCards.count == 2 else { //Leave if there aren't two items in flippedCards
            return
        }
        
        isCheckingMatch = true //Ensures no other cards can be flipped
        
        //These are the flag and country or "cards" chosen by user
        let firstCard = flippedCards[0], secondCard = flippedCards[1]
        
        //If there's a dictionary match for either variable (the keys in the dict are flags, so check both for flag)
        if countryDict[firstCard] == secondCard || countryDict[secondCard] == firstCard {
            matchMessage = "Match Found" //Alert the user that a match was found
            lockCards(firstCard, secondCard) //Lock the cards that resulted in Valid Matches
            matchesMade += 1 //Increment Matches Made
            
            //The reward for a match is 1000 - time penalty, with the timepenalty based off how long between the current and last match. This makes sure there's some incentive to finish fast
            let timeBonus = max(10000 - Int(Date().timeIntervalSince(lastFlipTime)) * 10, 0)
            
            score += timeBonus //Increment score by timeBonus reward
            
            if matchesMade == 6 { //Check to see if this was the last Match to make!!! -> Game Over
                if timePassed < 120 {
                    endMessage = "Woah, you're quick!"
                }
                showAlert = true
                timer?.invalidate()
                saveGame()
            } else {
                lastFlipTime = Date() //Update the LastFlippedTime if not
            }
            
        } else {
            matchMessage = "Match Not Found"
            score -= 250 //Subtract score by penalty
        }
        
        //After a delay of 1 second to perform these actions
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            matchMessage = "" //reset matchMessage to ""
            unflipAll() //Unflip all the cards (Locked cards won't flip)
            isCheckingMatch = false //Reset isCheckingMatch flag
            flippedCards.removeAll() //Reset the arr of flipped cards
        }
    }
    
    
    //This Function will Restart the Game
    func restartGame() {
        self.newGame = GenerateCards() //Generate new cards
        self.flippedCards = [] //Reset flipped cards
        self.matchMessage = "" //Clear message
        self.score = 0 //Reset score
        self.startTime = Date() //Reset starttime
        self.timePassed = 0 //Reset timepassed
        self.matchesMade = 0 //Reset matches made
        self.showAlert = false //Reset alert bool
        self.endMessage = "Good Game!" //Reset the End Message
        //Restart the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                let currentTime = Date()
                timePassed = Int(currentTime.timeIntervalSince(startTime))
        }
    }
    
    //This will just format the time, as I'm currently using an int
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    //There's probably a better way to keep up with the flippedCards, but with the "Decks" being so small. I just went through it
    func unflipAll() {
        for cards in newGame {
            if cards.isFlipped {
                cards.flipCard()
            }
        }
    }
    func lockCards( _ firstCard: String, _ secondCard: String) {
        for cards in newGame {
            if cards.back == firstCard || cards.back == secondCard {
                cards.isLocked = true
            }
        }
    }
    
    //Save the Game at the end
    func saveGame() {
        let savedGame = Game(timestamp: startTime, timeTaken: "\(formatTime(timePassed))", gameMatches: gameMatches, score: score)
        modelContext.insert(savedGame)
    }
}


#Preview {
    GameView()
}
