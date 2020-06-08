//
//  BoardView.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 5/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    private var cardContainerSize: CGSize {
        var size = CGSize.zero
        if subviews.count > 0 {
            for n in 1...subviews.count {
                size = calculateLargestPossibleSize(rowCount: n, currentSize: size)
            }
            for n in 1...subviews.count {
                size = calculateLargestPossibleSize(columnCount: n, currentSize: size)
            }
        }
        return size
    }
    
    private func calculateLargestPossibleSize(rowCount: Int? = nil, columnCount: Int? = nil, currentSize: CGSize) -> CGSize {
        var size = currentSize
        
        if let rowCount = rowCount {
            let columnCount = ceil(Double(subviews.count)/Double(rowCount))
            let rectHeight = bounds.height / CGFloat(rowCount)
            let rectWidth = rectHeight * CardViewConstants.cardAspectRatio
            if CGFloat(rowCount) * rectHeight <= bounds.height &&
                CGFloat(columnCount) * rectWidth <= bounds.width &&
                currentSize.width < rectWidth {
                
                size = CGSize(width: rectWidth, height: rectHeight)
            }
        } else if let columnCount = columnCount {
            let rowCount = ceil(Double(subviews.count)/Double(columnCount))
            let rectWidth = bounds.width / CGFloat(columnCount)
            let rectHeight = rectWidth / CardViewConstants.cardAspectRatio
            
            if CGFloat(rowCount) * rectHeight <= bounds.height &&
                CGFloat(columnCount) * rectWidth <= bounds.width &&
                currentSize.width < rectWidth {
                
                size = CGSize(width: rectWidth, height: rectHeight)
            }
        }
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if subviews.count > 0 {
            let numberOfColumns = Int(bounds.width/cardContainerSize.width)
            let numberOfRows = Int(ceil(Double(subviews.count)/Double(numberOfColumns)))
            let dx = cardContainerSize.width * CardViewConstants.cardPaddingToWidthRatio
            let dy = cardContainerSize.height * CardViewConstants.cardPaddingToHeightRatio
            let startingPoint = CGPoint(x: (bounds.width - cardContainerSize.width * CGFloat(numberOfColumns))/2,
                                        y: (bounds.height - cardContainerSize.height * CGFloat(numberOfRows))/2)

            for index in 0..<subviews.count {
                let cardView = subviews[index]
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.6,
                    delay: 0,
                    options: .allowUserInteraction,
                    animations: {
                        let cardWidth = self.cardContainerSize.width * (1 - 2*CardViewConstants.cardPaddingToWidthRatio)
                        let cardHeight = self.cardContainerSize.height * (1 - 2*CardViewConstants.cardPaddingToHeightRatio)
                        let columnNumber = (index %  numberOfColumns) + 1
                        let rowNumber = Int(index / numberOfColumns) + 1
                        
                        cardView.frame.size = CGSize(width: cardWidth, height: cardHeight)
                        cardView.frame.origin.x = startingPoint.x + (self.cardContainerSize.width - dx) * CGFloat(columnNumber - 1) + (dx * CGFloat(columnNumber))
                        cardView.frame.origin.y = startingPoint.y + (self.cardContainerSize.height - dy) * CGFloat(rowNumber - 1) + (dy * CGFloat(rowNumber))
                },
                    completion: nil
                )
                
            }
        }
    }
}
