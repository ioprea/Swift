//
//  Concentration.swift
//  Concentration
//
//  Created by Oprea Ionut on 10/05/2018.
//  Copyright © 2018 Oprea Ionut. All rights reserved.
//

import Foundation
extension Array {
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
    var indexOfOnlyOneFaceUp : Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var indexFound : Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if indexFound == nil {
//                        indexFound = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return indexFound
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var faceUpCards: [Int?] {
        return cards.indices.filter {
            cards[$0].isFaceUp
        }
    }
    
    
    func reset () {
        cards = [Card]()
        Card.myIdentifierFactory = 0
        indexOfOnlyOneFaceUp = nil
    }
    
    func chooseCard (at index:Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOnlyOneFaceUp, matchIndex != index {
                // One card is face up
                if cards[matchIndex] == cards[index]  {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                //Either no cards are face up or 2 cards are face up
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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
