//
//  Constants.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 5/7/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

struct GameConstants {
    static let initialNumberOfCards = 12
}

struct ShapeConstants {
    static let lineWidth: CGFloat = 2
    static let stripeWidth: CGFloat = 1
    static let widthToHeightRatio: CGFloat = 2
    static let distanceYRatio: CGFloat = 0.07
    static let maxNumberOfShapes: CGFloat = 3
}

struct CardViewConstants {
    static let cardHeightToWidthRatio: CGFloat = 1.6
    static let distanceToCardWidthRatio: CGFloat = 0.16
    static let cardPaddingToWidthRatio: CGFloat = 0.05
    static let cardPaddingToHeightRatio: CGFloat = 0.03
    static let initialCardSize: CGSize = CGSize(width: 800, height: 1280)
    static let cardAspectRatio: CGFloat = 0.63
}
