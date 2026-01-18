//
//  BenKimimHowToPlayView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct BenKimimHowToPlayView: View {
    let onStartGame: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LiquidGlassBackground()
                
                VStack(spacing: 0) {
                    // Top spacing
                    Spacer()
                        .frame(height: 90)
                    
                    // Header
                    VStack(spacing: 12) {
                        // Game Controller Icon
                        Text("🎮")
                            .font(.system(size: 60))
                        
                        // Title
                        Text("Ben Kimim?")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(.secondaryGradient)
                        
                        // Subtitle
                        Text("Telefonu karşına tut ve anlatmasını iste!")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Instructions Card
                    VStack(alignment: .leading, spacing: 20) {
                        // Card Title
                        HStack(spacing: 8) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.yellow)
                            
                            Text("Nasıl Oynanır?")
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 8)
                        
                        // Instruction Items
                        VStack(spacing: 16) {
                            // Step 1
                            InstructionItemView(
                                icon: "iphone.gen3",
                                iconColor: Color(red: 0.3, green: 0.6, blue: 0.9),
                                title: "Telefonu karşına tut",
                                checkmark: nil,
                                description: "Ekranı görmeden karşındakine göster"
                            )
                            
                            // Step 2
                            InstructionItemView(
                                icon: "person.wave.2.fill",
                                iconColor: Color(red: 0.95, green: 0.7, blue: 0.2),
                                title: "Karşındaki anlatsın",
                                checkmark: nil,
                                description: "İsmi söylemeden kişiyi tarif etsin"
                            )
                            
                            // Swipe actions
                            InstructionItemView(
                                icon: "hand.draw.fill",
                                iconColor: Color(red: 0.3, green: 0.8, blue: 0.5),
                                title: "Bildin mi?",
                                checkmark: true,
                                description: "Sağa kaydır ✓ veya Sola kaydır ✗"
                            )
                        }
                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    // Start Button
                    Button(action: onStartGame) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                            Text("Oyuna Başla")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.secondaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct InstructionItemView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let checkmark: Bool?
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(iconColor)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 6) {
                // Title with checkmark/X
                HStack(spacing: 8) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    if let checkmark = checkmark {
                        Image(systemName: checkmark ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(checkmark ? .green : .red)
                    }
                }
                
                // Description
                Text(description)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        BenKimimHowToPlayView {
            print("Start game")
        }
    }
}
