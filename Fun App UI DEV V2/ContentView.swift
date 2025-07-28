//
//  ContentView.swift
//  Cultural Bridge Quest
//
//  Created by Kaushik Manian on 19/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentScreen: GameScreen = .welcome
    @State private var teamNumber: String = ""
    @State private var teamName: String = ""
    @State private var selectedCulture: CultureType = .mixed
    @State private var lockerStates: [String: LockerState] = [
        "A": .locked,
        "B": .locked, 
        "C": .locked,
        "D": .locked,
        "E": .locked
    ]
    @State private var discoveredCode: String = ""
    @State private var puzzleCategories: [PuzzleCategory] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Apple-like background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                switch currentScreen {
                case .welcome:
                    WelcomeView(
                        teamNumber: $teamNumber,
                        teamName: $teamName,
                        selectedCulture: $selectedCulture,
                        onPlay: {
                            setupPuzzleCategories()
                            currentScreen = .puzzle
                        }
                    )
                case .puzzle:
                    PuzzleView(
                        lockerStates: $lockerStates,
                        discoveredCode: $discoveredCode,
                        teamName: teamName,
                        onScanClue: { currentScreen = .camera },
                        onSolve: { currentScreen = .welcome }
                    )
                case .camera:
                    CameraFilterView(
                        culture: selectedCulture,
                        onBack: { currentScreen = .puzzle },
                        onScanSuccess: { currentScreen = .categories }
                    )
                case .categories:
                    CategoriesView(
                        categories: $puzzleCategories,
                        culture: selectedCulture,
                        onComplete: { code in
                            discoveredCode = code
                            currentScreen = .codeRevealed
                        }
                    )
                case .codeRevealed:
                    CodeRevealedView(
                        code: discoveredCode,
                        teamName: teamName,
                        onDone: { currentScreen = .puzzle }
                    )
                }
            }
        }
    }
    
    private func setupPuzzleCategories() {
        switch selectedCulture {
        case .singapore:
            puzzleCategories = [
                PuzzleCategory(name: "Shiok", color: .red, culturalMeaning: "Awesome/Great"),
                PuzzleCategory(name: "Lah", color: .blue, culturalMeaning: "Emphasis particle"),
                PuzzleCategory(name: "Kiasu", color: .green, culturalMeaning: "Fear of losing out"),
                PuzzleCategory(name: "Bojio", color: .orange, culturalMeaning: "Why didn't you invite?"),
                PuzzleCategory(name: "Steady", color: .purple, culturalMeaning: "Cool/Reliable")
            ]
        case .indonesia:
            puzzleCategories = [
                PuzzleCategory(name: "Mantap", color: .red, culturalMeaning: "Awesome/Solid"),
                PuzzleCategory(name: "Santuy", color: .blue, culturalMeaning: "Chill/Relaxed"),
                PuzzleCategory(name: "Bucin", color: .green, culturalMeaning: "Lovesick"),
                PuzzleCategory(name: "Gabut", color: .orange, culturalMeaning: "Bored/Nothing to do"),
                PuzzleCategory(name: "Kepo", color: .purple, culturalMeaning: "Curious/Nosy")
            ]
        case .mixed:
            puzzleCategories = [
                PuzzleCategory(name: "Shiok", color: .red, culturalMeaning: "SG: Awesome/Great"),
                PuzzleCategory(name: "Santuy", color: .blue, culturalMeaning: "ID: Chill/Relaxed"),
                PuzzleCategory(name: "Kiasu", color: .green, culturalMeaning: "SG: Fear of losing out"),
                PuzzleCategory(name: "Kepo", color: .orange, culturalMeaning: "ID: Curious/Nosy"),
                PuzzleCategory(name: "Mantap", color: .purple, culturalMeaning: "ID: Awesome/Solid")
            ]
        }
    }
}

enum GameScreen {
    case welcome, puzzle, camera, categories, codeRevealed
}

enum LockerState {
    case locked, unlocked, solved
}

enum CultureType: String, CaseIterable {
    case singapore = "Singapore"
    case indonesia = "Indonesia" 
    case mixed = "Mixed (SG + ID)"
    
    var flag: String {
        switch self {
        case .singapore: return "🇸🇬"
        case .indonesia: return "🇮🇩"
        case .mixed: return "🇸🇬🇮🇩"
        }
    }
    
    var greeting: String {
        switch self {
        case .singapore: return "Welcome lah!"
        case .indonesia: return "Selamat datang!"
        case .mixed: return "Welcome / Selamat datang!"
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}