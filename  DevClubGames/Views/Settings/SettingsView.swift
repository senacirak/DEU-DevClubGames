//
//  SettingsView.swift
//   DEU DevClub Games
//
//  Created by Sena Çırak on 18.01.2026.
//

import SwiftUI

enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: "Sistem"
        case .light: "Açık"
        case .dark: "Koyu"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

struct SettingsView: View {
    @AppStorage("appAppearance") private var appAppearanceRawValue: String = AppAppearance.system.rawValue

    @State private var showingPrivacyPolicy = false
    @State private var showingFeedback = false

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsCard(title: "Görünüm", systemImage: "circle.lefthalf.filled") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Tema")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundStyle(.secondary)

                                Picker("Tema", selection: $appAppearanceRawValue) {
                                    ForEach(AppAppearance.allCases) { item in
                                        Text(item.title).tag(item.rawValue)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }

                        SettingsCard(title: "Gizlilik", systemImage: "hand.raised.fill") {
                            SettingsRow(
                                title: "Gizlilik Politikası",
                                subtitle: "Veri kullanımını ve saklama koşullarını görüntüle",
                                systemImage: "doc.text.magnifyingglass"
                            ) {
                                showingPrivacyPolicy = true
                            }
                        }

                        SettingsCard(title: "Destek", systemImage: "bubble.left.and.bubble.right.fill") {
                            SettingsRow(
                                title: "Geri Bildirim Gönder",
                                subtitle: "Öneri / hata bildirimi / istek",
                                systemImage: "paperplane.fill"
                            ) {
                                showingFeedback = true
                            }
                        }

                        // Hakkında (kart değil): küçük ve silik footer
                        Text("Sürüm \(Bundle.main.appVersion)")
                            .font(.caption2)
                            .foregroundStyle(.primary)
                            .opacity(0.8)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 6)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingPrivacyPolicy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showingFeedback) {
                FeedbackView()
            }
        }
    }
}

struct SettingsCard<Content: View>: View {
    let title: String
    let systemImage: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .foregroundStyle(.primaryGradient)
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.primary)
                Spacer()
            }

            content
        }
        .padding(16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct SettingsRow: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .foregroundStyle(.blue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Gizlilik Politikası")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundStyle(.primary)

                        Text("Son güncelleme: 18 Ocak 2026")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(.secondary)

                        PolicySection(title: "Topladığımız Veriler") {
                            Text("Bu uygulama, varsayılan olarak kişisel veri toplamaz. Oyun içi ayarlar (ör. tema) yalnızca cihazınızda saklanır.")
                        }

                        PolicySection(title: "Cihaz İçi Saklama") {
                            Text("Seçtiğiniz ayarlar (örn. açık/koyu mod) `AppStorage` üzerinden cihazınızda tutulur ve üçüncü taraflarla paylaşılmaz.")
                        }

                        PolicySection(title: "Geri Bildirim") {
                            Text("Geri bildirim gönderirken paylaştığınız içerik, tercih ettiğiniz kanal (Mail/Paylaş) üzerinden iletilir.")
                        }

                        PolicySection(title: "İletişim") {
                            Text("Gizlilik ile ilgili sorularınız için kulüp ekibi ile iletişime geçebilirsiniz.")
                        }
                    }
                    .padding(16)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.white.opacity(0.14), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Gizlilik")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
        }
    }
}

struct PolicySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary)
            content
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

struct FeedbackView: View {
    @Environment(\.dismiss) private var dismiss
    private let recipientEmail = "senacrk.dev@gmail.com"

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsCard(title: "E‑posta", systemImage: "envelope.fill") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Geri bildirim için şu adrese mail atabilirsiniz:")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)

                                if recipientEmail.isEmpty {
                                    Text("(E‑posta adresi tanımlı değil)")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.secondary)
                                } else {
                                    Link(recipientEmail, destination: URL(string: "mailto:\(recipientEmail)")!)
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Geri Bildirim")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}


