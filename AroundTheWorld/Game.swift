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
    var gameComplete: Bool
    var game: [String]
    var score: Int
    
    
    init(timestamp: Date, gameComplete: Bool, game: [String], score: Int) {
        self.timestamp = timestamp
        self.gameComplete = gameComplete
        self.game = game
        self.score = score
    }
}
