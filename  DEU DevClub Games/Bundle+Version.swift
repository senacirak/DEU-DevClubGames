//
//  Bundle+Version.swift
//   DEU DevClub Games
//
//  Created by Sena Çırak on 9.11.2025.
//

import Foundation

extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var appBuild: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    }
}


