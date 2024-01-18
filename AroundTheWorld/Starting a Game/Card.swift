//
//  Card.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/17/24.
//

import Foundation

class Card: ObservableObject{
    @Published var back: String
    @Published var isFlipped: Bool
    @Published var isLocked = false
    
    
    init(back: String, isFlipped: Bool) {
        self.back = back
        self.isFlipped = isFlipped
    }
    
    func flipCard() {
        if !isLocked {
            isFlipped.toggle()
        }
    }
}
