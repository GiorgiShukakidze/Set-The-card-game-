//
//  SetGame.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 4/29/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var cards = [Card]()
    private(set) var cardDeck = [Card]()
    private(set) var score = 0
    private(set) var successfullyMatchedCards = [Card]()
    var selectedCardIndices: [Int] {
        return cards.indices.filter {cards[$0].isSelected}
    }
    private var currentlyMatchedCardIndices: [Int] {
        return cards.indices.filter { cards[$0].isMatched }
    }
    
    func isFinished() -> Bool {
        return cards.filter { $0.isMatched }.count == cards.count
    }
    
    mutating func choseCard(atIndex index: Int) {
        if !successfullyMatchedCards.contains(cards[index]) {
            if selectedCardIndices.count == GameConstants.numberOfCardsToMatch {
                for index in selectedCardIndices {
                    cards[index].isSelected = false
                }
                cards[index].isSelected = !cards[index].isMatched
                if !currentlyMatchedCardIndices.isEmpty { dealMore() }
            } else {
                cards[index].isSelected = !cards[index].isSelected
                if selectedCardIndices.count == GameConstants.numberOfCardsToMatch { checkForMatchingCards() }
            }
        }
    }

    mutating func dealMore() {
        if cardDeck.count > 0 {
            for _ in 0..<GameConstants.numberOfCardsToMatch {
                let randomCard = cardDeck.remove(at: Int.random(in: 0..<cardDeck.count))
                if currentlyMatchedCardIndices.isEmpty {
                    cards.append(randomCard)
                } else if let matchedCardIndex = currentlyMatchedCardIndices.first {
                    successfullyMatchedCards.append(cards[matchedCardIndex])
                    cards[matchedCardIndex] = randomCard
                }
            }
        } else {
            successfullyMatchedCards.append(contentsOf: cards.elementsForIndices(indices: currentlyMatchedCardIndices))
        }
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    init (numberOfCardsDisplayed: Int) {
        
        for shape in Card.CardShape.allCases {
            for color in Card.CardColor.allCases {
                for shading in Card.CardShading.allCases {
                    for numberOfShape in Card.NumberOfShapes.allCases {
                        cardDeck.append(Card(numberOfShapes: numberOfShape,
                                             shape: shape,
                                             shading: shading,
                                             color: color
                        ))
                    }
                }
            }
        }
        
        for _ in 0..<numberOfCardsDisplayed {
            cards.append(cardDeck.remove(at: Int.random(in: 0..<cardDeck.count)))
        }
    }
    
    private mutating func checkForMatchingCards () {
        var colors = [Card.CardColor]()
        var shapes = [Card.CardShape]()
        var shadings = [Card.CardShading]()
        var numbers = [Card.NumberOfShapes]()

        for index in selectedCardIndices {
            let card = cards[index]
            colors.appendUnique(card.color)
            shapes.appendUnique(card.shape)
            shadings.appendUnique(card.shading)
            numbers.appendUnique(card.numberOfShapes)
        }

        if colors.count != 2 && shapes.count != 2 && shadings.count != 2 && numbers.count != 2 {
            for index in selectedCardIndices {
                cards[index].isMatched = true
            }
            score += 3
        } else {
            score -= 5
        }
    }
}

extension Array where Element: Equatable {
    func elementsForIndices(indices:[Int]) -> [Element] {
        var elements = [Element]()
        for index in indices {
            if index < self.count {
                elements.append(self[index])
            }
        }
        return elements
    }
    
    mutating func appendUnique(_ element: Element) {
        if !self.contains(element) { self.append(element)}
    }
}
