//
//  ThemeManager.swift
//  Memory Meadow
//

import Foundation
import Combine

@MainActor
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    @Published var currentTheme: MeadowTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedMeadowTheme")
        }
    }

    private init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedMeadowTheme")
        self.currentTheme = MeadowTheme(rawValue: savedTheme ?? "") ?? .spring
    }

    func setTheme(_ theme: MeadowTheme) {
        currentTheme = theme
    }
}
