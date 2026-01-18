//
//  HomeView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedGame: Game?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Liquid Glass Background
                LiquidGlassBackground()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // DEU DevClub Header
                        VStack(spacing: 8) {
                            // DEU DevClub - Kompakt
                            HStack(spacing: 2) {
                                Text("D")
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundStyle(.yellow)
                                Text("E")
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundStyle(.blue)
                                Text("U")
                                    .font(.system(size: 28, weight: .black, design: .rounded))
                                    .foregroundStyle(.red)
                                
                                Text(" DevClub")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundStyle(.green)
                            }
                            
                            // GAMES - Daha küçük
                            Text("GAMES")
                                .font(.system(size: 39, weight: .heavy, design: .rounded))
                                .foregroundStyle(.primaryGradient)
                                .tracking(1)
                            
                            // Küçük ayırıcı
                            HStack(spacing: 4) {
                                Circle().fill(.blue).frame(width: 4, height: 4)
                                Circle().fill(.yellow).frame(width: 4, height: 4)
                                Circle().fill(.green).frame(width: 4, height: 4)
                                Circle().fill(.red).frame(width: 4, height: 4)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal)
                        
                        // Games List
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.games) { game in
                                GameCardView(
                                    game: game,
                                    onTap: {
                                        viewModel.gameSelected(game)
                                        if game.isAvailable {
                                            selectedGame = game
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Footer
                        VStack {
                            Text("Developer Club")
                                .font(.caption)
                                .foregroundStyle(.primary)
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $viewModel.showingComingSoon) {
            if let game = viewModel.selectedUnavailableGame {
                ComingSoonView(game: game) {
                    viewModel.dismissComingSoon()
                }
            }
        }
        .fullScreenCover(item: $selectedGame) { game in
            GameNavigationView(game: game)
        }
    }
}

struct GameNavigationView: View {
    let game: Game
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            switch game.name {
            case "Tabu":
                TabuSettingsView()
            case "İnteraktif Hikayeler":
                StorySelectionView()
            case "Ben Kimim?":
                BenKimimGameView()
            default:
                ComingSoonView(game: game) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}

