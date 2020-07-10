//
//  ConfettiEmmiter.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 7/10/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ConfettiEmmiter: CAEmitterLayer {
    
    let colors = [#colorLiteral(red: 0.0208785015, green: 1, blue: 0.2038619593, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1, green: 0, blue: 0.2836754269, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9969027123, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 1, green: 0.254753598, blue: 0.7377768667, alpha: 1), #colorLiteral(red: 0.5096153846, green: 1, blue: 0.01923076923, alpha: 1), #colorLiteral(red: 0.3971149563, green: 0.9713168402, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.07394003131, blue: 0.9513432344, alpha: 1) ]
    let shapes = [UIImage(named: "Swirl"), UIImage(named: "Triangle"), UIImage(named: "RoundedRectangle"), UIImage(named: "Cirlce"), UIImage(named: "Star")]
    
    required init?(coder: NSCoder) {
        super .init(coder: coder)
    }
    
    init(width: CGFloat = 2.0, height: CGFloat = 2.0) {
        super.init()
        
        self.emitterPosition = CGPoint(x: width / 2, y: -10)
        self.emitterShape = CAEmitterLayerEmitterShape.line
        self.emitterSize = CGSize(width: width, height: height)
        self.emitterCells = generateEmitterCells()
        self.pause()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func pause() {
        if self.birthRate > 0 {
            self.birthRate = 0
        }
    }
    
    func play(withDuration duration: Double) {
        self.birthRate = 1
        
        Timer.scheduledTimer(
            withTimeInterval: duration,
            repeats: false) { (timer) in
                self.birthRate = 0
        }
    }
    
    private func generateEmitterCells() -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        
        for index in 0..<20 {
            let cell = CAEmitterCell()
            cell.birthRate = 3.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(200)
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 0
            cell.color = getNextColor(i: index)
            cell.contents = getNextImage(i: index)
            cell.scaleRange = 0.25
            cell.scale = 0.25
            cells.append(cell)
        }
            return cells
    }
    
    private func getNextColor(i index: Int) -> CGColor {
        
        let colorIndex = index % colors.count
        return colors[colorIndex].cgColor
    }
    
    private func getNextImage(i index: Int) -> CGImage? {
        
        let shapeIndex = index % shapes.count
        
        if let image = shapes[shapeIndex] {
            return image.cgImage!
        } else{
            return nil
        }
    }
}
