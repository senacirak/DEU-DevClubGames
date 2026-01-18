//
//  ContentView.swift
//  DEU DevClub Games
//
//  Created by Sena Çırak on 23.09.2025.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("appAppearance") private var appAppearanceRawValue: String = AppAppearance.system.rawValue

    var body: some View {
        RootTabView()
            .preferredColorScheme(AppAppearance(rawValue: appAppearanceRawValue)?.colorScheme)
    }
}

struct RootTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
