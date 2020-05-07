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
}

extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return
            lhs.shape == rhs.shape &&
            lhs.shading == rhs.shading &&
            lhs.color == rhs.color &&
            lhs.numberOfShapes == rhs.numberOfShapes
    }
}

enum NumberOfShapes: Int, CaseIterable {
    case one = 1, two = 2, three = 3
}

enum CardShape: String, CaseIterable {
    case triangle = "▲", squre = "■", circle = "●"
}

enum CardShading: CaseIterable {
    case solid, striped, open
}

enum CardColor: String, CaseIterable {
    case red, purple, green
}

