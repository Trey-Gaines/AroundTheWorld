//
//  Item.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/16/24.
//

import Foundation
import SwiftData

@Model
final class Game {
    var timestamp = Date()
    var timeTaken: String
    var gameMatches: [String:String]
    var score: Int
    
    
    init(timestamp: Date, timeTaken: String, gameMatches: [String:String], score: Int) {
        self.timestamp = timestamp
        self.timeTaken = timeTaken
        self.gameMatches = gameMatches
        self.score = score
    }
}
