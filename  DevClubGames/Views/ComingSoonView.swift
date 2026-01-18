//
//  ComingSoonView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI
import UserNotifications
import UIKit

struct ComingSoonView: View {
    let game: Game
    let onDismiss: () -> Void
    @State private var isAnimating = false
    
    @State private var isRequestingNotificationPermission = false
    @State private var showPermissionAlert = false
    @State private var permissionAlertTitle = ""
    @State private var permissionAlertMessage = ""
    @State private var shouldOfferOpenSettings = false
    
    var body: some View {
        ZStack {
            // Background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Modal Content
            VStack(spacing: 30) {
                // Icon with animation
                Text(game.icon)
                    .font(.system(size: 80))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                
                // Content
                VStack(spacing: 16) {
                    Text("Yakında Geliyor!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    Text(game.name)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(game.description)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                
                // Features Preview
                VStack(spacing: 12) {
                    Text("Özellikler:")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    
                    VStack(spacing: 8) {
                        FeatureRow(icon: "🎯", text: "Çoklu oyuncu desteği")
                        FeatureRow(icon: "🏆", text: "Liderlik tablosu")
                        FeatureRow(icon: "🎨", text: "Özelleştirilebilir temalar")
                        FeatureRow(icon: "📊", text: "Detaylı istatistikler")
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button("Bildirim Al") {
                        requestNotificationPermission()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(isRequestingNotificationPermission)
                    
                    Button("Kapat") {
                        onDismiss()
                    }
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(.secondary)
                }
            }
            .padding(30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        LinearGradient(
                            colors: gradientColors.map { $0.opacity(0.3) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
        .alert(permissionAlertTitle, isPresented: $showPermissionAlert) {
            if shouldOfferOpenSettings {
                Button("Ayarlar'a Git") {
                    openAppSettings()
                }
                Button("Vazgeç", role: .cancel) {}
            } else {
                Button("Tamam", role: .cancel) {}
            }
        } message: {
            Text(permissionAlertMessage)
        }
    }
    
    private var gradientColors: [Color] {
        game.gradient.compactMap { hex in
            Color(hex: hex)
        }
    }
    
    private func requestNotificationPermission() {
        guard !isRequestingNotificationPermission else { return }
        isRequestingNotificationPermission = true
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                DispatchQueue.main.async {
                    isRequestingNotificationPermission = false
                    shouldOfferOpenSettings = false
                    permissionAlertTitle = "Bildirimler Açık"
                    permissionAlertMessage = "Bildirim izni zaten verilmiş."
                    showPermissionAlert = true
                }
                
            case .denied:
                DispatchQueue.main.async {
                    isRequestingNotificationPermission = false
                    shouldOfferOpenSettings = true
                    permissionAlertTitle = "Bildirimler Kapalı"
                    permissionAlertMessage = "Bildirimleri açmak için Ayarlar > Bildirimler kısmından izin verebilirsin."
                    showPermissionAlert = true
                }
                
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    DispatchQueue.main.async {
                        isRequestingNotificationPermission = false
                        shouldOfferOpenSettings = !granted
                        permissionAlertTitle = granted ? "Teşekkürler!" : "İzin Verilmedi"
                        permissionAlertMessage = granted
                        ? "Artık bildirim gönderebiliriz."
                        : "Bildirim almak istersen Ayarlar'dan izni açabilirsin."
                        showPermissionAlert = true
                    }
                }
                
            @unknown default:
                DispatchQueue.main.async {
                    isRequestingNotificationPermission = false
                    shouldOfferOpenSettings = false
                    permissionAlertTitle = "Hata"
                    permissionAlertMessage = "Bildirim izni durumu okunamadı."
                    showPermissionAlert = true
                }
            }
        }
    }
    
    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 16))
            
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
            
            Spacer()
        }
    }
}

#Preview {
    ComingSoonView(game: Game.sampleGames[2]) {
        print("Dismissed")
    }
}

