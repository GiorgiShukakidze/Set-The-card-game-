//
//  Card.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 4/29/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Card {
    let numberOfShapes: NumberOfShapes
    let shape: CardShape
    let shading: CardShading
    let color: CardColor
    var isSelected = false
    var isMatched = false
    private var identifier: Int
    
    private static var uniqueIdentifier = 0
    private static func generateUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    init(numberOfShapes: NumberOfShapes, shape: CardShape, shading: CardShading, color: CardColor) {
        self.numberOfShapes = numberOfShapes
        self.shape = shape
        self.shading = shading
        self.color = color
        self.identifier = Card.generateUniqueIdentifier()
    }
}

extension Card: Hashable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.shape == rhs.shape &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color &&
            lhs.numberOfShapes == rhs.numberOfShapes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension Card {
    enum NumberOfShapes: Int, CaseIterable {
        case one = 1, two = 2, three = 3
        
        var index: Int {return self.rawValue - 1}
    }

    enum CardShape: Int, CaseIterable {
        case squiggle = 0, oval = 1, diamond = 2
    }

    enum CardShading: Int, CaseIterable {
        case solid = 0, striped = 1, open = 2
    }

    enum CardColor: Int, CaseIterable {
        case red = 0, purple = 1, green = 2
    }
}
