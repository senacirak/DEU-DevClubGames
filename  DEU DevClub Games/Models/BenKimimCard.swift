//
//  BenKimimCard.swift
//  DEU DevClub Games
//
//  Created on 27/09/2025.
//

import Foundation

struct BenKimimCard: Identifiable, Codable {
    let id = UUID()
    let personName: String
    let category: String
    let emoji: String
    
    init(personName: String, category: String, emoji: String) {
        self.personName = personName
        self.category = category
        self.emoji = emoji
    }
}

extension BenKimimCard {
    static let sampleCards: [BenKimimCard] = [
        // 🎬 Oyuncular & Komedyenler
        BenKimimCard(personName: "Cem Yılmaz", category: "Komedyen", emoji: "🎭"),
        BenKimimCard(personName: "Tolga Çevik", category: "Komedyen", emoji: "🎭"),
        BenKimimCard(personName: "Şahan Gökbakar", category: "Komedyen", emoji: "🎭"),
        BenKimimCard(personName: "Nejat İşler", category: "Oyuncu", emoji: "🎬"),
        BenKimimCard(personName: "Merve Boluğur", category: "Oyuncu", emoji: "🎬"),
        BenKimimCard(personName: "Kenan İmirzalıoğlu", category: "Oyuncu", emoji: "🎬"),
        BenKimimCard(personName: "Kıvanç Tatlıtuğ", category: "Oyuncu", emoji: "🎬"),
        BenKimimCard(personName: "Burak Özçivit", category: "Oyuncu", emoji: "🎬"),
        BenKimimCard(personName: "Hande Erçel", category: "Oyuncu", emoji: "🎬"),
        
        // 🎤 Şarkıcılar & Müzisyenler
        BenKimimCard(personName: "Tarkan", category: "Şarkıcı", emoji: "🎤"),
        BenKimimCard(personName: "Serdar Ortaç", category: "Şarkıcı", emoji: "🎤"),
        BenKimimCard(personName: "Teoman", category: "Şarkıcı", emoji: "🎸"),
        BenKimimCard(personName: "Hadise", category: "Şarkıcı", emoji: "🎤"),
        BenKimimCard(personName: "Sezen Aksu", category: "Şarkıcı", emoji: "🎤"),
        BenKimimCard(personName: "Müslüm Gürses", category: "Şarkıcı", emoji: "🎤"),
        BenKimimCard(personName: "Barış Manço", category: "Şarkıcı", emoji: "🎸"),
        BenKimimCard(personName: "Ajda Pekkan", category: "Şarkıcı", emoji: "🎤"),
        
        // 🎵 Rapçiler
        BenKimimCard(personName: "Ceza", category: "Rapçi", emoji: "🎵"),
        BenKimimCard(personName: "Sagopa Kajmer", category: "Rapçi", emoji: "🎵"),
        BenKimimCard(personName: "Cakal", category: "Rapçi", emoji: "🎵"),
        BenKimimCard(personName: "LVBEL C5", category: "Rapçi", emoji: "🎵"),
        BenKimimCard(personName: "Murda", category: "Rapçi", emoji: "🎵"),
        BenKimimCard(personName: "Ezhel", category: "Rapçi", emoji: "🎵"),
        
        // ⚽️ Sporcular
        BenKimimCard(personName: "Arda Güler", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Fatih Terim", category: "Teknik Direktör", emoji: "⚽️"),
        BenKimimCard(personName: "Alex de Souza", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Hakan Şükür", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Rıdvan Dilmen", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Volkan Demirel", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Emre Belözoğlu", category: "Futbolcu", emoji: "⚽️"),
        BenKimimCard(personName: "Enes Kanter", category: "Basketbolcu", emoji: "🏀"),
        
        // 📺 YouTuber & Streamer
        BenKimimCard(personName: "Elraen", category: "Yayıncı", emoji: "🎮"),
        BenKimimCard(personName: "Orkun Işıtmak", category: "YouTuber", emoji: "📺"),
        BenKimimCard(personName: "Enes Batur", category: "YouTuber", emoji: "📺"),
        BenKimimCard(personName: "Pqueen", category: "Yayıncı", emoji: "🎮"),
        BenKimimCard(personName: "Jahrein", category: "Yayıncı", emoji: "🎮"),
        BenKimimCard(personName: "Wtcn", category: "Yayıncı", emoji: "🎮"),
        
        // 💼 İş İnsanları
        BenKimimCard(personName: "Elon Musk", category: "Girişimci", emoji: "🚀"),
        BenKimimCard(personName: "Jeff Bezos", category: "Girişimci", emoji: "📦"),
        BenKimimCard(personName: "Mark Zuckerberg", category: "Girişimci", emoji: "📱"),
        BenKimimCard(personName: "Acun Ilıcalı", category: "Medya Patronu", emoji: "📺"),
        BenKimimCard(personName: "Ali Koç", category: "İş İnsanı", emoji: "💼"),
        BenKimimCard(personName: "Steve Jobs", category: "Girişimci", emoji: "🍎"),
        BenKimimCard(personName: "Bill Gates", category: "Girişimci", emoji: "💻"),
        
        // 🔬 Bilim İnsanları
        BenKimimCard(personName: "Albert Einstein", category: "Fizikçi", emoji: "🔬"),
        BenKimimCard(personName: "Marie Curie", category: "Bilim İnsanı", emoji: "🔬"),
        BenKimimCard(personName: "Nikola Tesla", category: "Mucit", emoji: "⚡️"),
        BenKimimCard(personName: "Stephen Hawking", category: "Fizikçi", emoji: "🔬"),
        BenKimimCard(personName: "Aziz Sancar", category: "Bilim İnsanı", emoji: "🔬"),
        
        // 🦸 Süper Kahramanlar & Karakterler
        BenKimimCard(personName: "Batman", category: "Süper Kahraman", emoji: "🦇"),
        BenKimimCard(personName: "Superman", category: "Süper Kahraman", emoji: "🦸"),
        BenKimimCard(personName: "Iron Man", category: "Süper Kahraman", emoji: "🤖"),
        BenKimimCard(personName: "Thor", category: "Süper Kahraman", emoji: "⚡️"),
        BenKimimCard(personName: "Hulk", category: "Süper Kahraman", emoji: "💪"),
        BenKimimCard(personName: "Spider-Man", category: "Süper Kahraman", emoji: "🕷️"),
        BenKimimCard(personName: "Harry Potter", category: "Film Karakteri", emoji: "🧙"),
        BenKimimCard(personName: "Darth Vader", category: "Film Karakteri", emoji: "⚔️"),
        
        // 📺 Dizi Karakterleri
        BenKimimCard(personName: "Polat Alemdar", category: "Dizi Karakteri", emoji: "🎬"),
        BenKimimCard(personName: "Recep İvedik", category: "Film Karakteri", emoji: "🎬"),
        BenKimimCard(personName: "Behzat Ç.", category: "Dizi Karakteri", emoji: "🔍"),
        BenKimimCard(personName: "Hekimoğlu", category: "Dizi Karakteri", emoji: "🏥"),
        
        // 🌐 Meme & Internet Fenomeni
        BenKimimCard(personName: "Kandıralı Ferdi", category: "Internet Fenomeni", emoji: "🌐"),
        BenKimimCard(personName: "Kadıköy Boğası", category: "Internet Fenomeni", emoji: "🌐"),
        BenKimimCard(personName: "Yakışıklı Güvenlik", category: "Internet Fenomeni", emoji: "🌐"),
        BenKimimCard(personName: "Testo Taylan", category: "Internet Fenomeni", emoji: "🌐"),
        BenKimimCard(personName: "Güven Demir", category: "Internet Fenomeni", emoji: "🌐"),
        BenKimimCard(personName: "Buders", category: "YouTuber", emoji: "📺"),
        
        // 🎤 Sunucular
        BenKimimCard(personName: "Kenan Işık", category: "Sunucu", emoji: "🎙️"),
        BenKimimCard(personName: "Mehmet Ali Erbil", category: "Sunucu", emoji: "🎙️"),
        BenKimimCard(personName: "Beyazıt Öztürk", category: "Sunucu", emoji: "🎙️"),
        
        // 🏆 Tarihi Figürler
        BenKimimCard(personName: "Atatürk", category: "Devlet Adamı", emoji: "🇹🇷"),
        BenKimimCard(personName: "Fatih Sultan Mehmet", category: "Padişah", emoji: "👑"),
        BenKimimCard(personName: "Kanuni Sultan Süleyman", category: "Padişah", emoji: "👑"),
        BenKimimCard(personName: "Mimar Sinan", category: "Mimar", emoji: "🏛️"),
        BenKimimCard(personName: "Yunus Emre", category: "Şair", emoji: "📜"),
        BenKimimCard(personName: "Nazım Hikmet", category: "Şair", emoji: "📜"),
    ]
}
