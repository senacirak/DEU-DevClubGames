//
//  BenKimimScoreView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct BenKimimScoreView: View {
    let score: Int
    let correctCount: Int
    let passCount: Int
    let totalCards: Int
    let onRestart: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            LiquidGlassBackground()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Trophy Icon
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.warningGradient)
                
                // Score
                VStack(spacing: 8) {
                    Text("Skorunuz")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("\(score)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundStyle(.yellow)
                }
                
                // Stats
                VStack(spacing: 16) {
                    StatRowView(
                        icon: "checkmark.circle.fill",
                        iconColor: .green,
                        label: "Doğru",
                        value: "\(correctCount)"
                    )
                    
                    StatRowView(
                        icon: "xmark.circle.fill",
                        iconColor: .red,
                        label: "Pas",
                        value: "\(passCount)"
                    )
                    
                    StatRowView(
                        icon: "person.fill",
                        iconColor: Color(red: 0.3, green: 0.4, blue: 0.7),
                        label: "Toplam Kişi",
                        value: "\(totalCards)"
                    )
                }
                .padding(24)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.quaternary, lineWidth: 1)
                )
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Buttons
                VStack(spacing: 16) {
                    Button(action: onRestart) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18, weight: .semibold))
                            
                            Text("Tekrar Oyna")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.secondaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Button(action: onDismiss) {
                        Text("Ana Menüye Dön")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
}

struct StatRowView: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 30)
            
            Text(label)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.yellow)
        }
    }
}

#Preview {
    BenKimimScoreView(
        score: 250,
        correctCount: 25,
        passCount: 11,
        totalCards: 36,
        onRestart: {},
        onDismiss: {}
    )
}
