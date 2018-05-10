//
//  Concentration.swift
//  Concentration
//
//  Created by Oprea Ionut on 10/05/2018.
//  Copyright © 2018 Oprea Ionut. All rights reserved.
//

import Foundation
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

class Concentration {
    
    var cards = [Card]()
    var indexOfOnlyOneFaceUp : Int?
    
    func chooseCard (at index:Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOnlyOneFaceUp, matchIndex != index {
                // One card is face up
                if cards[matchIndex].identifier == cards[index].identifier  {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
                indexOfOnlyOneFaceUp = nil
                
            } else {
                //Either no cards are face up or 2 cards are face up
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
                indexOfOnlyOneFaceUp = index
            }
        }
    }
    
    init(numberOfPairs: Int) {
        for identifier in 0..<numberOfPairs {
            let card = Card(identifier: identifier)
            cards += [card, card]
        }
        // TODO: Shuffle the cards
        cards.shuffle()
    }
}
