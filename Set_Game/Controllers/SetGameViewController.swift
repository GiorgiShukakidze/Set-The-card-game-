//
//  ViewController.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 4/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = SetGame(numberOfCardsDisplayed: 12)

    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var gameButtons: [UIButton]! {
        didSet {
            for button in gameButtons {
                button.layer.cornerRadius = 8
            }
        }
    }
    @IBOutlet private weak var dealMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewModel()
    }
    
    @IBAction private func cardTouched(_ sender: UIButton) {
        if let selectedCardIndex = cardButtons.firstIndex(of: sender), selectedCardIndex < game.cards.count {
            game.choseCard(atIndex: selectedCardIndex)
            updateViewModel()
        }
    }
    
    @IBAction private func dealMorePressed(_ sender: UIButton) {
        if cardButtons.count > game.cards.count {
            game.dealMore()
            updateViewModel()
        }
    }
    
    @IBAction private func newGamePressed(_ sender: UIButton) {
        for button in cardButtons {
            clearView(for: button)
        }
        game = SetGame(numberOfCardsDisplayed: 12)
        updateViewModel()
    }
    
// Update view according to cards model
    private func updateViewModel() {
        for index in game.cards.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            
            if game.successfullyMatchedCards.contains(card) {
                clearView(for: button)
            } else {
                button.setAttributedTitle(faceForCard(for: card), for: .normal)
                button.backgroundColor = card.isSelected ? .white : .lightGray
                button.layer.cornerRadius = 8
                button.layer.borderColor = UIColor.clear.cgColor
                if game.selectedCardIndices.count == 3 && card.isSelected {
                    button.layer.borderWidth = 3
                    button.layer.borderColor = card.isMatched ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                }
            }
        }
        dealMoreButton.isHidden = game.cardDeck.isEmpty
        scoreLabel.text = "Score: \(game.score)"
    }
    
// Generate face for card according to its traits
    private func faceForCard(for card: Card) -> NSAttributedString {
        let cardColor = { () -> UIColor in
            switch card.color {
                case .green: return UIColor.green
                case.purple: return UIColor.purple
                case.red: return UIColor.red
            }
        }()
        
        let alpha = { () -> CGFloat in
            switch card.shading {
                case .open: return 0
                case .solid: return 1
                case .striped: return 0.15
            }
        }()
        
        let cardFace = String(repeating: card.shape.rawValue, count: card.numberOfShapes.rawValue)
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor : cardColor.withAlphaComponent(alpha),
            .strokeColor : cardColor,
            .strokeWidth : -5,
            .font : UIFont.systemFont(ofSize: 25)
        ]
        
        return NSAttributedString(string: cardFace, attributes: attributes)
    }
    
// Make button transperent
    private func clearView(for button: UIButton) {
        button.backgroundColor = .clear
        button.setAttributedTitle(nil, for: .normal)
        button.layer.borderColor = UIColor.clear.cgColor
    }
}
