//
//  CardView.swift
//  AroundTheWorld
//
//  Created by Trey Gaines on 1/17/24.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var thisCard: Card
    @Binding var flippedCards: [String]
    @Binding var isCheckingMatch: Bool
    
    init(thisCard: Card, flippedCards: Binding<[String]>, isCheckingMatch: Binding<Bool>) {
        self.thisCard = thisCard
        self._flippedCards = flippedCards
        self._isCheckingMatch = isCheckingMatch
    }
    
    var body: some View {
        Button(action: {
            if flippedCards.count < 2 && !thisCard.isLocked && !isCheckingMatch {
                thisCard.flipCard()
                flippedCards.append(thisCard.back)
            }
        }) {
            if thisCard.isFlipped { //if the card is flipped display the flag/countru
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                    
                    //I wanted the flags to be big, but this made the text wrap. Text().linelimit acts upon the whole string, so I used forEach on the cardString and gave it a linelimit.
                    VStack {
                        ForEach(thisCard.back.split(separator: " ").map(String.init), id: \.self) { word in
                            Text(word)
                                .foregroundColor(.black)
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                }
            }
            else { //If not show the "front" of the card
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview
        let card = Card(back: "United States of America", isFlipped: false)
        let flippedCards = Binding.constant(["🇺🇸"])
        let isCheckingMatch = Binding.constant(false)

        CardView(thisCard: card, flippedCards: flippedCards, isCheckingMatch: isCheckingMatch)
            .previewLayout(.fixed(width: 300, height: 400))
    }
}
