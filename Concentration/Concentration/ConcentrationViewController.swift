//
//  ViewController.swift
//  Concentration
//
//  Created by Oprea Ionut on 09/05/2018.
//  Copyright © 2018 Oprea Ionut. All rights reserved.
//

import UIKit


class ConcentrationViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairs: (cardButtons.count + 1)/2)
    
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCount()
        }
    }
    @IBOutlet var cardButtons: [UIButton]!
    
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCount()
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        emojiChoices = emojiConstant
        emoji = [Card:String]()
        game = Concentration(numberOfPairs: (cardButtons.count + 1)/2)
        flipCount = 0
        updateViewFromModel()
        cardButtons.forEach {
            $0.alpha = 1
            $0.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            $0.setTitle("", for: UIControlState.normal)
        }
    }
    
    private func updateFlipCount () {
        let attribute: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.orange
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attribute)
        flipCountLabel.attributedText = attributedString
    }
    
    private var faceUpCardViews: [Card] {
        return game.cards.filter { $0.isFaceUp }
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].isMatched == true &&
            faceUpCardViews[1].isMatched == true
    }
    var lastButton: UIButton?
    
    @IBAction func cardAction(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            lastButton = sender
            if faceUpCardViews.count < 2 {
                UIView.transition(with: sender,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    self.game.chooseCard(at: cardNumber)
                                    self.updateViewFromModel()
                },
                                  completion: { finished in
                                    if self.game.faceUpCards.count == 2 {
                                        let first = self.game.faceUpCards[0]
                                        let second = self.game.faceUpCards[1]
                                        if self.game.cards[first!].isMatched && self.game.cards[second!].isMatched {
                                            UIView.transition(with: sender,
                                                              duration: 0.6,
                                                              options: [],
                                                              animations: {
                                                                self.cardButtons[first!].alpha = 0
                                                                self.cardButtons[second!].alpha = 0
                                                                self.game.cards[first!].isFaceUp = false
                                                                self.game.cards[second!].isFaceUp = false

                                            })
                                        } else {
                                            if (sender == self.lastButton) {
                                                UIView.transition(with:  self.cardButtons[first!],
                                                                  duration: 0.6,
                                                                  options: [.transitionFlipFromLeft],
                                                                  animations: {
                                                                    self.game.cards[first!].isFaceUp = false
                                                                    self.cardButtons[first!].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                                                                    self.cardButtons[first!].setTitle("", for: UIControlState.normal)
                                                })
                                                UIView.transition(with:  self.cardButtons[second!],
                                                                  duration: 0.6,
                                                                  options: [.transitionFlipFromLeft],
                                                                  animations: {
                                                                    self.game.cards[second!].isFaceUp = false
                                                                    self.cardButtons[second!].backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                                                                    self.cardButtons[second!].setTitle("", for: UIControlState.normal)
                                                })
                                            }
                                            
                                            
                                            //self.updateViewFromModel()
                                        }
                                    }
                                    
                })
            }
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        } else {
            print("Error")
        }
        
    }
    
    func updateViewFromModel () {
        if cardButtons != nil {
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for:  UIControlState.normal)
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                } else {
                    button.setTitle("", for:  UIControlState.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                }
            }
        }
    }  
    
    //var emojiChoices = ["🎃", "👻", "🤡", "😻", "🌔", "🌎", "🌈", "🍑", "🍔"]
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emojiConstant = theme ?? ""
            emoji = [:]
            updateViewFromModel() 
        }
    }
    
    var emojiConstant = "🎃👻🤡😻🌔🌎🌈🍑🍔"
    var emojiChoices = "🎃👻🤡😻🌔🌎🌈🍑🍔"
    var emoji = [Card:String]()
    
    func emoji(for card:Card) -> String {
        
        if emoji[card] == nil,  emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
        
    }
    
    func flipCard (withEmoji emoji:String, on button:UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for:  UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        } else {
            button.setTitle(emoji, for:  UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }

}

extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

