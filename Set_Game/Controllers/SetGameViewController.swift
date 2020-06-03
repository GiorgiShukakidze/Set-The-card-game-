//
//  ViewController.swift
//  Set_Game
//
//  Created by Giorgi Shukakidze on 4/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class SetGameViewController: UIViewController {
    
    private var game = SetGame(numberOfCardsDisplayed: GameConstants.initialNumberOfCards)
    
    @IBOutlet weak var cardsBoard: BoardView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private var gameButtons: [UIButton]! {
        didSet {
            for button in gameButtons {
                button.layer.cornerRadius = 8
            }
        }
    }
    
    @IBOutlet private weak var dealMoreButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateViewModel()
    }
    
    @IBAction private func dealMorePressed(_ sender: UIButton) {
        game.dealMore()
        updateViewModel()
    }
    
    @IBAction private func newGamePressed(_ sender: UIButton) {
        for pair in cardFaces {
            clearView(for: pair.key)
        }
        cardFaces = [:]
        game = SetGame(numberOfCardsDisplayed: GameConstants.initialNumberOfCards)
        updateViewModel()
    }
    
    var cardFaces = [Card:CardView]()
    
    // Update view according to cards model
    private func updateViewModel() {
        cardsBoard.clearSubviews()
        
        for index in game.cards.indices {
            let card = game.cards[index]
            let cardView = faceForCard(for: card)
            
            if game.successfullyMatchedCards.contains(card) {
                clearView(for: card)
            } else {
                cardView.backgroundColor = .white
                cardView.layer.borderWidth = 3
                cardView.layer.borderColor = card.isSelected ? #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                if game.selectedCardIndices.count == 3 && card.isSelected { cardView.layer.borderColor = card.isMatched ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) }
                cardsBoard.addSubview(cardView)
            }
        }
        
        dealMoreButton.isHidden = game.cardDeck.isEmpty
        scoreLabel.text = "Score: \(game.score)"
    }
    
    //MARK: - Utilities
    
    // Generate face for card according to its traits
    private func faceForCard(for card: Card) -> CardView {
        if let faceForCard = cardFaces[card] {
            return faceForCard
        } else {
            let cardFace = CardView(frame: CGRect(), shape: card.shape, color: card.color, shading: card.shading, numberOfShapes: card.numberOfShapes)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
            cardFace.addGestureRecognizer(tapGesture)
            
            cardFaces[card] = cardFace
            return cardFace
        }
    }
    
    // Tap gesture selector
    @objc func cardTapped(_ gesture: UITapGestureRecognizer) {
        if let cardView = gesture.view,
            let card = cardFaces.first(where: { $0.value == cardView })?.key,
            let cardIndex = game.cards.firstIndex(of: card)
        {
            game.choseCard(atIndex: cardIndex)
            updateViewModel()
        }
    }
    
    // Make view transperent
    private func clearView(for card: Card) {
        if let faceForCard = cardFaces[card] {
            faceForCard.removeFromSuperview()
        }
    }
}

extension UIView {
    func clearSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
