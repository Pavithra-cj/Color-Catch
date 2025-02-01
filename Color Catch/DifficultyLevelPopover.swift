//
//  DifficultyLevelPopover.swift
//  Color Catch
//
//  Created by Pavithra Chamod on 2025-02-02.
//

import SwiftUI

enum GameDifficulty {
    case easy
    case medium
    case hard
    
    var gridSize: Int {
        switch self {
        case .easy: return 3
        case .medium: return 4
        case .hard: return 5
        }
    }
}

struct DifficultySelectionView: View {
    @Binding var isPresented: Bool
    var onDifficultySelected: (GameDifficulty) -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Select Difficulty")
                    .font(.title)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    difficultyButton(title: "Easy (3×3)", difficulty: .easy)
                    difficultyButton(title: "Medium (4×4)", difficulty: .medium)
                    difficultyButton(title: "Hard (5×5)", difficulty: .hard)
                }
                .padding()
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .frame(width: 300)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
    
    private func difficultyButton(title: String, difficulty: GameDifficulty) -> some View {
        Button(action: {
            onDifficultySelected(difficulty)
            isPresented = false
        }) {
            Text(title)
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}
