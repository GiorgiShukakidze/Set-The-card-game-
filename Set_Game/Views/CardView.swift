//
//  CardView.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 5/7/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class CardView: UIView {
    let shape: Card.CardShape?
    let color: Card.CardColor?
    let shading: Card.CardShading?
    let numberOfShapes: Card.NumberOfShapes?
    let colors = [#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
    
    init (frame: CGRect, shape: Card.CardShape, color: Card.CardColor, shading: Card.CardShading, numberOfShapes: Card.NumberOfShapes ) {
        self.shape = shape
        self.color = color
        self.shading = shading
        self.numberOfShapes = numberOfShapes
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.shape = nil
        self.color = nil
        self.shading = nil
        self.numberOfShapes = nil
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        if let shapeColor = color {
            colors[shapeColor.rawValue].setStroke()
            colors[shapeColor.rawValue].setFill()
        }
        
        let rectHeight = bounds.height * (1 - 6 * ShapeConstants.distanceYRatio) / ShapeConstants.maxNumberOfShapes
        let rectWidth = rectHeight * ShapeConstants.widthToHeightRatio
        let rectX = bounds.minX + (bounds.width - rectWidth)/2
        let rectY = bounds.midY - (bounds.height/2 * CGFloat(numberOfShapes!.rawValue) / 4)
        let containerRect = CGRect(x: rectX, y: rectY, width: rectWidth, height: rectHeight)

        switch shape {
        case .diamond: drawDiamond(in: containerRect)
        case .oval: drawOval(in: containerRect)
        case .squiggle: drawSquiggle(in: containerRect)
        case .none: break
        }
    }
    
    //MARK: - Draw diamond shape
    
    func drawDiamond(in containerRect: CGRect) {
        
        let dy = containerRect.height + bounds.height * ShapeConstants.distanceYRatio
        let diamondFacePath = UIBezierPath()
        
        for n in 0..<numberOfShapes!.rawValue {
            let diamondPath = UIBezierPath()
            diamondPath.move(to: CGPoint(x: containerRect.minX + containerRect.width/2, y: containerRect.minY + CGFloat(n) * dy))
            diamondPath.addLine(to: CGPoint(x: containerRect.maxX, y: containerRect.midY + CGFloat(n) * dy))
            diamondPath.addLine(to: CGPoint(x: containerRect.midX, y: containerRect.maxY + CGFloat(n) * dy))
            diamondPath.addLine(to: CGPoint(x: containerRect.minX, y: containerRect.midY + CGFloat(n) * dy))
            diamondPath.close()
            diamondFacePath.append(diamondPath)
        }
        
        diamondFacePath.lineWidth = ShapeConstants.lineWidth
        diamondFacePath.stroke()
        diamondFacePath.addClip()
        
        switch shading {
        case .striped: stripeShape()
        case .solid: diamondFacePath.fill()
        default: break
        }
    }
    
    //MARK: - Draw oval shape
    
    func drawOval(in containerRect: CGRect) {
        
        let dy = containerRect.height + bounds.height * ShapeConstants.distanceYRatio
        let ovalFacePath = UIBezierPath()
        
        for n in 0..<numberOfShapes!.rawValue {
            let ovalPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: containerRect.minX, y: containerRect.minY + CGFloat(n) * dy),
                                                            size: CGSize(width: containerRect.width, height: containerRect.height)),
                                        cornerRadius: containerRect.height)
            ovalFacePath.append(ovalPath)
        }
        
        ovalFacePath.lineWidth = ShapeConstants.lineWidth
        ovalFacePath.stroke()
        
        switch shading {
        case .striped:
            ovalFacePath.addClip()
            stripeShape()
        case .solid: ovalFacePath.fill()
        default: break
        }
    }
    
    //MARK: - Draw squiggle shape
    
    func drawSquiggle(in originalContainerRect: CGRect) {
        let dy = originalContainerRect.height + bounds.height * ShapeConstants.distanceYRatio
        let squiggleFacePath = UIBezierPath()
               
        for n in 0..<numberOfShapes!.rawValue {
            let containerRect = originalContainerRect.applying(CGAffineTransform.identity.translatedBy(x: 0, y: CGFloat(n) * dy))
            
            let topSide = UIBezierPath()
            topSide.lineJoinStyle = .round
            topSide.move(to: CGPoint(x: containerRect.minX + containerRect.width * 0.05, y: containerRect.midY))
            topSide.addCurve(to: CGPoint(x: containerRect.minX + containerRect.width/3, y: containerRect.minY + containerRect.height/10),
                             controlPoint1: CGPoint(x: containerRect.minX + containerRect.width/20, y: containerRect.minY + containerRect.height/3),
                             controlPoint2: CGPoint(x: containerRect.minX + containerRect.width/6, y: containerRect.minY)
            )
            topSide.addCurve(to: CGPoint(x: containerRect.minX + containerRect.width*2/3, y: containerRect.minY + containerRect.height*0.2),
                             controlPoint1: CGPoint(x: containerRect.minX + containerRect.width*0.5, y: containerRect.minY + containerRect.height/4),
                             controlPoint2: CGPoint(x: containerRect.minX + containerRect.width*0.6, y: containerRect.minY + containerRect.height/4)
            )
            topSide.addCurve(to: CGPoint(x: containerRect.minX + containerRect.width * 0.95, y: containerRect.midY),
                             controlPoint1: CGPoint(x: containerRect.minX + containerRect.width * 0.8, y: containerRect.minY + containerRect.height/6),
                             controlPoint2: CGPoint(x: containerRect.maxX, y: containerRect.minY - containerRect.height*0.5)
            )
            
            let bottomSide = UIBezierPath(cgPath: topSide.cgPath)
            bottomSide.lineJoinStyle = .round
            bottomSide.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
            bottomSide.apply(CGAffineTransform.identity.translatedBy(x: bounds.width, y: topSide.currentPoint.y * 2))
            topSide.append(bottomSide)
            squiggleFacePath.append(topSide)
        }
        
        squiggleFacePath.lineWidth = ShapeConstants.lineWidth
        squiggleFacePath.stroke()
        squiggleFacePath.addClip()
        
        switch shading {
        case .striped:
            squiggleFacePath.addClip()
            stripeShape()
        case .solid: squiggleFacePath.fill()
        default: break
        }
    }
    
    //MARK: - Utilities
    
    func stripeShape() {
        let stripePath = UIBezierPath()
        stripePath.move(to: CGPoint(x: bounds.minX + bounds.width*0.02, y: 0))
        stripePath.addLine(to: CGPoint(x: bounds.minX + bounds.width*0.01, y: bounds.maxY))
        stripePath.lineWidth = ShapeConstants.stripeWidth
        stripePath.stroke()
        for _ in 1...50 {
            stripePath.apply(CGAffineTransform.identity.translatedBy(x: bounds.width*0.02, y: 0))
            stripePath.lineWidth = ShapeConstants.stripeWidth
            stripePath.stroke()
        }
    }
}
