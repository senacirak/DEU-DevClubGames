//
//  BenKimimGameViewModel.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation
import SwiftUI

class BenKimimGameViewModel: ObservableObject {
    @Published var cards: [BenKimimCard] = []
    @Published var currentCardIndex: Int = 0
    @Published var score: Int = 0
    @Published var correctCount: Int = 0
    @Published var passCount: Int = 0
    @Published var isGameFinished: Bool = false
    @Published var cardOffset: CGSize = .zero
    @Published var cardRotation: Double = 0
    @Published var showHowToPlay: Bool = true
    
    var currentCard: BenKimimCard? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var progress: Double {
        guard !cards.isEmpty else { return 0 }
        return Double(currentCardIndex) / Double(cards.count)
    }
    
    var remainingCards: Int {
        return max(0, cards.count - currentCardIndex)
    }
    
    init() {
        loadCards()
    }
    
    func loadCards() {
        cards = BenKimimCard.sampleCards.shuffled()
        currentCardIndex = 0
        score = 0
        correctCount = 0
        passCount = 0
        isGameFinished = false
    }
    
    func startGame() {
        showHowToPlay = false
        loadCards()
    }
    
    func swipeRight() {
        guard currentCardIndex < cards.count else { return }
        correctCount += 1
        score += 10
        moveToNextCard()
    }
    
    func swipeLeft() {
        guard currentCardIndex < cards.count else { return }
        passCount += 1
        moveToNextCard()
    }
    
    private func moveToNextCard() {
        // Reset position and move to next card immediately
        cardOffset = .zero
        cardRotation = 0
        
        // Move to next card after a brief delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let self = self else { return }
            self.currentCardIndex += 1
            
            if self.currentCardIndex >= self.cards.count {
                self.isGameFinished = true
            }
        }
    }
    
    func resetCardPosition() {
        // Reset card position with smooth spring animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
            cardOffset = .zero
            cardRotation = 0
        }
    }
    
    func restartGame() {
        loadCards()
        showHowToPlay = false
        resetCardPosition()
    }

    func backToHowToPlay() {
        showHowToPlay = true
        isGameFinished = false
        resetCardPosition()
    }
    
    func updateCardOffset(_ offset: CGSize) {
        // Clamp values to prevent extreme animations
        let clampedWidth = max(-500, min(500, offset.width))
        let clampedHeight = max(-500, min(500, offset.height))
        
        // Update offset and rotation values
        // These will not animate because they're updated during drag
        cardOffset = CGSize(width: clampedWidth, height: clampedHeight)
        cardRotation = Double(clampedWidth / 20)
    }
    
    func handleDragEnd(_ offset: CGSize) {
        let threshold: CGFloat = 100
        
        if abs(offset.width) > threshold {
            if offset.width > 0 {
                swipeRight()
            } else {
                swipeLeft()
            }
        } else {
            resetCardPosition()
        }
    }
}

