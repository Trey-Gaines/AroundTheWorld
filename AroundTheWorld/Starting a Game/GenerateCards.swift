//
//  CreateGame.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/17/24.
//

import Foundation

func GenerateCards() -> [Card] {
    //These are all the possible combinations for the application. Used a list of tuples
    let countryFlags = [("🇺🇸","United States of America"),
                       ("🇰🇪","Kenya"), ("🇨🇳","China"), ("🇮🇳","India"),
                       ("🇮🇩","Indonesia"), ("🇵🇰","Pakistan"), ("🇧🇷","Brazil"),
                       ("🇳🇬","Nigeria"), ("🇧🇩","Bangladesh"), ("🇷🇺","Russia"),
                       ("🇲🇽","Mexico"), ("🇯🇵","Japan"), ("🇵🇭","Philippines"),
                       ("🇪🇬","Egypt"), ("🇪🇹","Ethiopia"), ("🇻🇳","Vietnam"),
                       ("🇮🇷","Iran"), ("🇹🇷","Turkey"), ("🇩🇪","Germany"),
                       ("🇫🇷","France"), ("🇹🇭","Thailand"), ("🇬🇧","United Kingdom"),
                       ("🇮🇹","Italy"), ("🇿🇦","South Africa"), ("🇰🇷","South Korea"),
                       ("🇪🇸","Spain"), ("🇸🇩","Sudan"), ("🇵🇱","Poland"),
                       ("🇨🇦","Canada"), ("🇦🇺","Australia"), ("🇸🇪","Sweden"),
                       ("🇩🇰","Denmark"), ("🇸🇬","Singapore"), ("🇫🇮","Finland"),
                       ("🇬🇷","Greece"), ("🇳🇱","Netherlands"), ("🇭🇺","Hungary")]
    
    var flagsAdded: Set<String> = [] //Use a set to see if something's already been added
    var gameCards: [Card] = [] //Array of Cards to use for the game

    while gameCards.count < 12 { // You need 12 cards (6 pairs) in total
        let randomIndex = Int.random(in: 0..<countryFlags.count)
        let newPair = countryFlags[randomIndex]

        //Check set to see if flag has already been added
        if !flagsAdded.contains(newPair.0) {
            gameCards.append(Card(back: newPair.0, isFlipped: false))
            gameCards.append(Card(back: newPair.1, isFlipped: false))
            flagsAdded.insert(newPair.0) //Add the flag to the set
        }
     }
    
    return gameCards.shuffled() //Shuffle cards before returning
    }

