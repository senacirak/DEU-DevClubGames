//
//  BenKimimGameView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct BenKimimGameView: View {
    @StateObject private var viewModel = BenKimimGameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()
                
                if viewModel.showHowToPlay {
                    BenKimimHowToPlayView {
                        viewModel.startGame()
                    }
                } else if viewModel.isGameFinished {
                    BenKimimScoreView(
                        score: viewModel.score,
                        correctCount: viewModel.correctCount,
                        passCount: viewModel.passCount,
                        totalCards: viewModel.cards.count,
                        onRestart: {
                            viewModel.restartGame()
                        },
                        onDismiss: {
                            dismiss()
                        }
                    )
                } else {
                    gameContentView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
//            // Navigation bar sadece HowToPlay’da görünür (oyun/score ekranlarında görünmez)
//            .toolbar(viewModel.showHowToPlay ? .visible : .hidden, for: .navigationBar)
//            .toolbar {
//                if viewModel.showHowToPlay {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 16, weight: .semibold))
//                                .foregroundStyle(.primary)
//                        }
//                    }
//                }
//            }
        }
    }
    
    private var gameContentView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Çıkış") {
                    viewModel.backToHowToPlay()
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
                
                Spacer()
                // Score Display
                HStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("Doğru")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(viewModel.correctCount)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.green)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(spacing: 4) {
                        Text("Pas")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(viewModel.passCount)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.red)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(spacing: 4) {
                        Text("Skor")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                        Text("\(viewModel.score)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(.yellow)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Card Stack
            ZStack {
                if let currentCard = viewModel.currentCard {
                    CardView(
                        card: currentCard,
                        offset: viewModel.cardOffset,
                        rotation: viewModel.cardRotation,
                        onOffsetChange: { newOffset in
                            viewModel.updateCardOffset(newOffset)
                        },
                        onDragEnd: { finalOffset in
                            viewModel.handleDragEnd(finalOffset)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            
            // Bottom Buttons
            HStack(spacing: 20) {
                // Pass Button
                Button(action: {
                    viewModel.swipeLeft()
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 32))
                        Text("PAS")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 100)
                    .padding(.vertical, 16)
                    .background(.errorGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                // Correct Button
                Button(action: {
                    viewModel.swipeRight()
                }) {
                    VStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                        Text("DOĞRU")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .frame(width: 100)
                    .padding(.vertical, 16)
                    .background(.successGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            
            // Progress Bar
            HStack(spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 4)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.yellow)
                            .frame(width: geometry.size.width * viewModel.progress, height: 4)
                    }
                }
                .frame(height: 4)
                
                Text("\(viewModel.currentCardIndex + 1)/\(viewModel.cards.count)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(width: 50, alignment: .trailing)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }
}

// MARK: - CardView (Yeni Tasarım - Sadece İsim)
struct CardView: View {
    let card: BenKimimCard
    let offset: CGSize
    let rotation: Double
    let onOffsetChange: (CGSize) -> Void
    let onDragEnd: (CGSize) -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    // Kategori renklerini belirle
    private var categoryColor: Color {
        switch card.category {
        case "Komedyen", "Oyuncu":
            return Color(red: 0.9, green: 0.3, blue: 0.4)
        case "Şarkıcı", "Rapçi":
            return Color(red: 0.6, green: 0.2, blue: 0.8)
        case "Futbolcu", "Teknik Direktör", "Basketbolcu":
            return Color(red: 0.2, green: 0.7, blue: 0.3)
        case "YouTuber", "Yayıncı":
            return Color(red: 0.95, green: 0.3, blue: 0.3)
        case "Girişimci", "İş İnsanı", "Medya Patronu":
            return Color(red: 0.2, green: 0.5, blue: 0.9)
        case "Bilim İnsanı", "Fizikçi", "Mucit":
            return Color(red: 0.1, green: 0.7, blue: 0.7)
        case "Süper Kahraman", "Film Karakteri", "Dizi Karakteri":
            return Color(red: 0.95, green: 0.5, blue: 0.1)
        case "Internet Fenomeni":
            return Color(red: 0.95, green: 0.7, blue: 0.2)
        case "Sunucu":
            return Color(red: 0.5, green: 0.3, blue: 0.7)
        case "Devlet Adamı", "Padişah", "Mimar", "Şair":
            return Color(red: 0.6, green: 0.5, blue: 0.3)
        default:
            return Color(red: 0.5, green: 0.5, blue: 0.5)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Emoji
            Text(card.emoji)
                .font(.system(size: 80))
                .padding(.bottom, 20)
            
            // İsim - BÜYÜK FONT
            Text(card.personName.uppercased())
                .font(.system(size: 42, weight: .black, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(.horizontal, 20)
            
            // Kategori
            Text(card.category)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(categoryColor.opacity(0.6))
                .clipShape(Capsule())
                .padding(.top, 24)
            
            Spacer()
            
            // Alt kısım - Swipe ipucu
            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .semibold))
                    Text("PAS")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.4))
                
                VStack(spacing: 4) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 20, weight: .semibold))
                    Text("DOĞRU")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.white.opacity(0.4))
            }
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIScreen.main.bounds.height * 0.50)
        .background(
            LinearGradient(
                colors: [
                    categoryColor.opacity(0.8),
                    categoryColor.opacity(0.4),
                    Color.black.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(categoryColor.opacity(0.5), lineWidth: 2)
        )
        .shadow(color: categoryColor.opacity(0.3), radius: 20, x: 0, y: 10)
        .offset(isDragging ? dragOffset : offset)
        .rotationEffect(.degrees(isDragging ? Double(dragOffset.width / 20) : rotation))
        .scaleEffect(1.0 - abs(isDragging ? Double(dragOffset.width / 20) : rotation) / 1000)
        .gesture(
            DragGesture(minimumDistance: 10)
                .onChanged { value in
                    if !isDragging {
                        isDragging = true
                    }
                    let clampedWidth = max(-500, min(500, value.translation.width))
                    let clampedHeight = max(-500, min(500, value.translation.height))
                    dragOffset = CGSize(width: clampedWidth, height: clampedHeight)
                    onOffsetChange(value.translation)
                }
                .onEnded { value in
                    isDragging = false
                    onDragEnd(value.translation)
                }
        )
    }
}

#Preview {
    NavigationStack {
        BenKimimGameView()
    }
}
