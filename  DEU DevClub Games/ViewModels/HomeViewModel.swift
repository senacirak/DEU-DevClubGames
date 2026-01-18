//
//  HomeViewModel.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var showingComingSoon = false
    @Published var selectedUnavailableGame: Game?
    
    init() {
        loadGames()
    }
    
    private func loadGames() {
        games = [
            Game(name: "Tabu", 
                 icon: "🎭", 
                 description: "Takım oyunu – yasaklı kelimeleri kullanmadan anlat!", 
                 isAvailable: true,
                 gradient: ["#667eea", "#764ba2"]),
            
            Game(name: "İnteraktif Hikayeler", 
                 icon: "📚", 
                 description: "Seçeneklere göre hikaye ilerleyecek - yaratıcılığını konuştur!", 
                 isAvailable: true,
                 gradient: ["#4facfe", "#00f2fe"]),
            
            Game(name: "Ben Kimim?", 
                 icon: "🎮", 
                 description: "Ünlü kişileri tanıma oyunu - sağa kaydır doğru, sola kaydır pas!", 
                 isAvailable: true,
                 gradient: ["#6B5B95", "#8B7BAE"]),
            
            Game(name: "Startup Challenge", 
                 icon: "🚀", 
                 description: "Fikir sunma yarışması - yaratıcı startup fikirleri geliştir!", 
                 isAvailable: false,
                 gradient: ["#ff6b6b", "#4ecdc4"])
        ]
    }
    
    func gameSelected(_ game: Game) {
        if !game.isAvailable {
            selectedUnavailableGame = game
            showingComingSoon = true
        }
    }
    
    func dismissComingSoon() {
        showingComingSoon = false
        selectedUnavailableGame = nil
    }
}

