//
//  SettingsView.swift
//  DEU DevClub Games
//
//  Created by Cursor on 18.01.2026.
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

                        SettingsCard(title: "Hakkında", systemImage: "info.circle.fill") {
                            VStack(spacing: 12) {
                                InfoRow(title: "Sürüm", value: Bundle.main.appVersion)
                                InfoRow(title: "Build", value: Bundle.main.appBuild)
                            }
                        }
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
    @Environment(\.openURL) private var openURL

    @State private var feedbackText: String = ""
    @State private var showingMailComposer = false
    @State private var mailResultMessage: String?

    private let subject = "DEU DevClub Games – Geri Bildirim"
    private let defaultRecipientEmail = "senacrk.dev@gmail.com"

    var body: some View {
        NavigationStack {
            ZStack {
                LiquidGlassBackground()

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsCard(title: "Mesajın", systemImage: "square.and.pencil") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Ne iyi gitti? Ne geliştirelim? Hata varsa adımları yaz.")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundStyle(.secondary)

                                TextEditor(text: $feedbackText)
                                    .frame(minHeight: 160)
                                    .scrollContentBackground(.hidden)
                                    .padding(10)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                                    )
                            }
                        }

                        SettingsCard(title: "Gönder", systemImage: "paperplane.fill") {
                            VStack(spacing: 12) {
                                ShareLink(item: feedbackPayload) {
                                    Label("Paylaş (Mail / Mesaj / Notlar…)", systemImage: "square.and.arrow.up")
                                        .frame(maxWidth: .infinity)
                                }
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .padding()
                                .background(.primaryGradient)
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                                Button {
                                    if MailComposeView.canSendMail {
                                        showingMailComposer = true
                                    } else {
                                        openURL(makeMailtoURL())
                                    }
                                } label: {
                                    Label("Mail ile Gönder", systemImage: "envelope.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(.blue)

                                if let mailResultMessage {
                                    Text(mailResultMessage)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        SettingsCard(title: "Hızlı Bilgi", systemImage: "wrench.and.screwdriver.fill") {
                            VStack(spacing: 10) {
                                InfoRow(title: "Sürüm", value: Bundle.main.appVersion)
                                InfoRow(title: "Build", value: Bundle.main.appBuild)
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
            .sheet(isPresented: $showingMailComposer) {
                MailComposeView(
                    recipients: defaultRecipientEmail.isEmpty ? [] : [defaultRecipientEmail],
                    subject: subject,
                    body: feedbackPayload
                ) { resultMessage in
                    mailResultMessage = resultMessage
                }
            }
        }
    }

    private var feedbackPayload: String {
        let text = feedbackText.trimmingCharacters(in: .whitespacesAndNewlines)
        let userText = text.isEmpty ? "(Mesaj boş)" : text
        return """
        \(subject)

        Mesaj:
        \(userText)

        Teknik Bilgi:
        - Sürüm: \(Bundle.main.appVersion) (\(Bundle.main.appBuild))
        """
    }

    private func makeMailtoURL() -> URL {
        let recipient = defaultRecipientEmail
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        let encodedBody = feedbackPayload.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? feedbackPayload
        let urlString: String
        if recipient.isEmpty {
            urlString = "mailto:?subject=\(encodedSubject)&body=\(encodedBody)"
        } else {
            urlString = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"
        }
        return URL(string: urlString) ?? URL(string: "mailto:")!
    }
}

#if canImport(MessageUI)
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    static var canSendMail: Bool { MFMailComposeViewController.canSendMail() }

    let recipients: [String]
    let subject: String
    let body: String
    let onFinish: (String?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFinish: onFinish)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private let onFinish: (String?) -> Void

        init(onFinish: @escaping (String?) -> Void) {
            self.onFinish = onFinish
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            controller.dismiss(animated: true)

            if let error {
                onFinish("Mail gönderilemedi: \(error.localizedDescription)")
                return
            }

            switch result {
            case .cancelled: onFinish("İptal edildi.")
            case .saved: onFinish("Taslak olarak kaydedildi.")
            case .sent: onFinish("Gönderildi, teşekkürler!")
            case .failed: onFinish("Gönderim başarısız oldu.")
            @unknown default: onFinish(nil)
            }
        }
    }
}
#else
struct MailComposeView: View {
    static var canSendMail: Bool { false }

    let recipients: [String]
    let subject: String
    let body: String
    let onFinish: (String?) -> Void

    var body: some View {
        Text("Mail gönderimi bu cihazda desteklenmiyor.")
            .onAppear { onFinish(nil) }
    }
}
#endif

#Preview {
    SettingsView()
}


