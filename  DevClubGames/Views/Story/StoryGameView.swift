//
//  StoryGameView.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import SwiftUI

struct StoryGameView: View {
    @StateObject private var viewModel = StoryGameViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showCharacterInfo = false
    
    var body: some View {
        ZStack {
            // Basit karanlık arka plan
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Top Bar
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Çıkış")
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Capsule())
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Story Content
                    if let scene = viewModel.currentScene {
                        VStack(spacing: 20) {
                            // Scene Title
                            if !scene.title.isEmpty {
                                Text(scene.title)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.7))
                                    .textCase(nil)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            // Story Passage
                            VStack(alignment: .leading, spacing: 0) {
                                formattedStoryText(cleanHTMLContent(scene.content))
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            // Character Info Button
                            if let characterInfo = scene.characterInfo, !characterInfo.isEmpty {
                                Button(action: {
                                    showCharacterInfo.toggle()
                                }) {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                        Text("Karakterler")
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                                
                                if showCharacterInfo {
                                    Text(characterInfo)
                                        .font(.system(size: 14, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .padding(20)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.05))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .padding(.horizontal)
                                        .transition(.opacity.combined(with: .scale))
                                }
                            }
                            
                            // Choices
                            if !scene.choices.isEmpty && !scene.isEnding {
                                VStack(spacing: 16) {
                                    Text("Seçiminiz:")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundStyle(.white.opacity(0.9))
                                    
                                    ForEach(scene.choices) { choice in
                                        Button(action: {
                                            withAnimation {
                                                viewModel.makeChoice(choice)
                                            }
                                        }) {
                                            HStack {
                                                Text(cleanChoiceText(choice.text))
                                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "arrow.right")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundStyle(.white.opacity(0.7))
                                            }
                                            .padding(18)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                                            .clipShape(RoundedRectangle(cornerRadius: 14))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14)
                                                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                        .simultaneousGesture(
                                            TapGesture().onEnded { _ in
                                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                                generator.impactOccurred()
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Ending Screen
                            if scene.isEnding {
                                VStack(spacing: 20) {
                                    Text("Hikaye Bitti")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.7))
                                    
                                    Button(action: {
                                        viewModel.restartStory()
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: "arrow.clockwise")
                                            Text("Yeniden Oyna")
                                                .font(.system(size: 18, weight: .semibold))
                                        }
                                        .foregroundStyle(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .background(Color.white.opacity(0.15))
                                        .clipShape(Capsule())
                                    }
                                }
                                .padding(.vertical, 40)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.currentScene == nil {
                viewModel.startStory()
            }
        }
    }
    
    // MARK: - Helper Functions
    private func cleanHTMLContent(_ content: String) -> String {
        var cleaned = content
        
        // Önce <br> etiketlerini satır atlamasına çevir
        cleaned = cleaned.replacingOccurrences(of: "<br>", with: "\n")
        cleaned = cleaned.replacingOccurrences(of: "<br/>", with: "\n")
        cleaned = cleaned.replacingOccurrences(of: "<br />", with: "\n")
        
        // Span etiketlerini temizle (içeriği koru)
        let spanPattern = #"<span[^>]*>(.*?)</span>"#
        if let regex = try? NSRegularExpression(pattern: spanPattern, options: []) {
            let range = NSRange(location: 0, length: cleaned.utf16.count)
            cleaned = regex.stringByReplacingMatches(in: cleaned, options: [], range: range, withTemplate: "$1")
        }
        
        // Tüm HTML etiketlerini temizle (içeriği koru)
        let htmlTagPattern = #"<[^>]+>"#
        if let regex = try? NSRegularExpression(pattern: htmlTagPattern, options: []) {
            let range = NSRange(location: 0, length: cleaned.utf16.count)
            cleaned = regex.stringByReplacingMatches(in: cleaned, options: [], range: range, withTemplate: "")
        }
        
        // HTML entity'leri decode et
        cleaned = cleaned.replacingOccurrences(of: "&quot;", with: "\"")
        cleaned = cleaned.replacingOccurrences(of: "&#39;", with: "'")
        cleaned = cleaned.replacingOccurrences(of: "&amp;", with: "&")
        cleaned = cleaned.replacingOccurrences(of: "&lt;", with: "<")
        cleaned = cleaned.replacingOccurrences(of: "&gt;", with: ">")
        cleaned = cleaned.replacingOccurrences(of: "&nbsp;", with: " ")
        
        // Fazla boşlukları temizle - 2+ boşlukları tek boşluğa çevir
        cleaned = cleaned.replacingOccurrences(of: "  +", with: " ", options: .regularExpression)
        // Fazla satır atlamalarını temizle - 2+ satır atlamasını tek satıra çevir
        cleaned = cleaned.replacingOccurrences(of: "\n\n+", with: "\n", options: .regularExpression)
        // Başta ve sonda boşlukları temizle
        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return cleaned
    }
    
    private func cleanChoiceText(_ text: String) -> String {
        var cleaned = text
        
        // "->" işaretini temizle
        cleaned = cleaned.replacingOccurrences(of: "->", with: "")
        cleaned = cleaned.replacingOccurrences(of: "→", with: "")
        
        // Fazla boşlukları temizle
        cleaned = cleaned.trimmingCharacters(in: .whitespaces)
        
        return cleaned
    }
    
    // MARK: - Formatted Text View
    @ViewBuilder
    private func formattedStoryText(_ text: String) -> some View {
        let processedText = processStoryText(text)
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(processedText.enumerated()), id: \.offset) { index, item in
                if item.isCharacter {
                    // Karakter tanımlaması
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text(item.name ?? "")
                                .font(.system(size: 17, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                            
                            if let role = item.role {
                                Text("(\(role))")
                                    .font(.system(size: 15, weight: .medium, design: .default))
                                    .foregroundStyle(.white.opacity(0.75))
                            }
                            
                            Text(":")
                                .font(.system(size: 17, weight: .bold, design: .default))
                                .foregroundStyle(.white)
                        }
                        
                        if let description = item.description {
                            Text(description)
                                .font(.system(size: 16, design: .default))
                                .foregroundStyle(.white.opacity(0.95))
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.bottom, 16)
                } else {
                    // Normal paragraf
                    if !item.text.isEmpty {
                        Text(item.text)
                            .font(.system(size: 16, design: .default))
                            .foregroundStyle(.white)
                            .lineSpacing(8)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, index < processedText.count - 1 ? 16 : 0)
                    }
                }
            }
        }
    }
    
    private struct TextItem {
        let text: String
        let isCharacter: Bool
        let name: String?
        let role: String?
        let description: String?
        
        init(text: String) {
            self.text = text
            self.isCharacter = false
            self.name = nil
            self.role = nil
            self.description = nil
        }
        
        init(name: String, role: String, description: String) {
            self.text = ""
            self.isCharacter = true
            self.name = name
            self.role = role
            self.description = description
        }
    }
    
    private func processStoryText(_ text: String) -> [TextItem] {
        var items: [TextItem] = []
        
        // Önce karakter tanımlamalarını bul ve işaretle
        var processedText = text
        var characterMatches: [(range: NSRange, name: String, role: String, description: String)] = []
        
        // Karakter tanımlaması pattern'i: "İsim (Rol): "Açıklama"
        let characterPattern = #"\"([^\"]+)\s*\(([^\)]+)\):\s*\"([^\"]+)\""#
        
        if let regex = try? NSRegularExpression(pattern: characterPattern, options: []) {
            let matches = regex.matches(in: processedText, options: [], range: NSRange(location: 0, length: processedText.utf16.count))
            
            for match in matches.reversed() {
                if match.numberOfRanges >= 4 {
                    let nameRange = Range(match.range(at: 1), in: processedText)!
                    let roleRange = Range(match.range(at: 2), in: processedText)!
                    let descRange = Range(match.range(at: 3), in: processedText)!
                    
                    let name = String(processedText[nameRange]).trimmingCharacters(in: .whitespaces)
                    let role = String(processedText[roleRange]).trimmingCharacters(in: .whitespaces)
                    let description = String(processedText[descRange]).trimmingCharacters(in: .whitespaces)
                    
                    characterMatches.append((range: match.range, name: name, role: role, description: description))
                }
            }
        }
        
        // Metni karakter tanımlamalarına göre böl
        var lastIndex = 0
        
        for match in characterMatches.sorted(by: { $0.range.location < $1.range.location }) {
            // Önceki metin parçasını ekle
            if match.range.location > lastIndex {
                let beforeText = String(processedText[processedText.index(processedText.startIndex, offsetBy: lastIndex)..<processedText.index(processedText.startIndex, offsetBy: match.range.location)])
                    .trimmingCharacters(in: .whitespaces)
                
                if !beforeText.isEmpty {
                    let paragraphs = splitIntoParagraphs(beforeText)
                    for paragraph in paragraphs {
                        if !paragraph.trimmingCharacters(in: .whitespaces).isEmpty {
                            items.append(TextItem(text: paragraph.trimmingCharacters(in: .whitespaces)))
                        }
                    }
                }
            }
            
            // Karakter tanımlamasını ekle
            items.append(TextItem(name: match.name, role: match.role, description: match.description))
            
            lastIndex = match.range.location + match.range.length
        }
        
        // Kalan metni ekle
        if lastIndex < processedText.utf16.count {
            let remainingText = String(processedText[processedText.index(processedText.startIndex, offsetBy: lastIndex)...])
                .trimmingCharacters(in: .whitespaces)
            
            if !remainingText.isEmpty {
                let paragraphs = splitIntoParagraphs(remainingText)
                for paragraph in paragraphs {
                    if !paragraph.trimmingCharacters(in: .whitespaces).isEmpty {
                        items.append(TextItem(text: paragraph.trimmingCharacters(in: .whitespaces)))
                    }
                }
            }
        }
        
        // Eğer hiç karakter tanımlaması yoksa, tüm metni paragraflara ayır
        if items.isEmpty {
            let paragraphs = splitIntoParagraphs(text)
            for paragraph in paragraphs {
                if !paragraph.trimmingCharacters(in: .whitespaces).isEmpty {
                    items.append(TextItem(text: paragraph.trimmingCharacters(in: .whitespaces)))
                }
            }
        }
        
        return items
    }
    
    private func splitIntoParagraphs(_ text: String) -> [String] {
        // Metni düzgün paragraflara ayır
        var paragraphs: [String] = []
        
        // Önce metni cümle sonlarına göre böl
        var sentences: [String] = []
        var currentSentence = ""
        
        for char in text {
            currentSentence.append(char)
            if ".!?".contains(char) {
                let trimmed = currentSentence.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    sentences.append(trimmed)
                }
                currentSentence = ""
            }
        }
        
        // Kalan metni ekle
        if !currentSentence.trimmingCharacters(in: .whitespaces).isEmpty {
            sentences.append(currentSentence.trimmingCharacters(in: .whitespaces))
        }
        
        // Cümleleri paragraflara grupla (her 2-3 cümle bir paragraf)
        var currentParagraph = ""
        
        for (index, sentence) in sentences.enumerated() {
            if currentParagraph.isEmpty {
                currentParagraph = sentence
            } else {
                currentParagraph += " " + sentence
            }
            
            // Paragrafı tamamla (her 2-3 cümlede bir veya 250+ karakter)
            if currentParagraph.count > 250 || (index > 0 && index % 3 == 0) || index == sentences.count - 1 {
                let trimmed = currentParagraph.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    paragraphs.append(trimmed)
                }
                currentParagraph = ""
            }
        }
        
        // Kalan paragrafı ekle
        if !currentParagraph.trimmingCharacters(in: .whitespaces).isEmpty {
            paragraphs.append(currentParagraph.trimmingCharacters(in: .whitespaces))
        }
        
        return paragraphs.isEmpty ? [text.trimmingCharacters(in: .whitespaces)] : paragraphs
    }
}

#Preview {
    StoryGameView()
}
