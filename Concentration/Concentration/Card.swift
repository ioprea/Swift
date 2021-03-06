//
//  Card.swift
//  Concentration
//
//  Created by Oprea Ionut on 10/05/2018.
//  Copyright © 2018 Oprea Ionut. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int {return identifier}
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isMatched = false
    var isFaceUp = false 
    private var identifier:Int
    static var myIdentifierFactory = 0
    
    static func getUniqueIdentifier () -> Int {
        Card.myIdentifierFactory += 1
        return Card.myIdentifierFactory
    }
    init(identifier: Int) {
        self.identifier = Card.getUniqueIdentifier()
    }
}


