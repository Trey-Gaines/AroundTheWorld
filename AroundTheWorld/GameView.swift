//
//  GameView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/17/24.
//

import SwiftUI

struct GameView: View {
    var newGame = GenerateCards()
    @State private var flippedCards: [String] = []
    @State private var matchMessage = ""
    @State private var score = 0
    @State private var isCheckingMatch = false
    @State private var lastFlipTime = Date()
    @State private var timePassed = 0
    @State private var startTime = Date()
    
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
                    Text("Time: \(formatTime(timePassed))")
                        .font(.title3)
                        .bold()
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
            .cornerRadius(3)
        
            .onAppear() {
                startTime = Date()
            }
        
            //OnRecieve is new to me but I found out it can be used to update a variable every second based on a timer.
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                let currentTime = Date()
                timePassed = Int(currentTime.timeIntervalSince(startTime))
            }
        
            .onDisappear() {
                timePassed = 0
            }
        
            .onChange(of: flippedCards) {
                if flippedCards.count == 2 {
                    checkForMatch()
            }
        }
    }
    
    
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
            
            //The reward for a match is 1000 - time penalty, with the timepenalty based off how long between the current and last match. This makes sure there's some incentive to finish fast
            let timeBonus = max(10000 - Int(Date().timeIntervalSince(lastFlipTime)) * 10, 0)
            
            score += timeBonus //Increment score by timeBonus reward
            
            lastFlipTime = Date() //Update the LastFlippedTime
            
        } else {
            matchMessage = "Match Not Found"
            score -= 250 //Subtract score by penalty
        }
        
        //After a delay of 2 seconds perform these actions
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            matchMessage = "" //reset matchMessage to ""
            unflipAll() //Unflip all the cards (Locked cards won't flip)
            isCheckingMatch = false //Reset the isCheckingMatch flag
            flippedCards.removeAll() //Reset the arr of flipped cards
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
}


#Preview {
    GameView()
}
