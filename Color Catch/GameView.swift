//
//  GameView.swift
//  Color Catch
//
//  Created by Pavithra Chamod on 2025-01-25.
//

import SwiftUI

struct GameView: View {
    @State private var colors: [Color] = []
    @State private var selectedIndices: [Int] = []
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 30
    @State private var isTimerRunning = false
    @State private var showGameOverAlert = false
    @State private var isGameOver = false
    @State private var showMainMenu = false

    let gridSize = 3
    let timerInterval = 1.0

    var body: some View {
        VStack {
            // Timer and Score Display
            HStack {
                Text("Time: \(formatTime(timeRemaining))")
                    .font(.title2)
                    .padding()
                Spacer()
                Text("Score: \(score)")
                    .font(.title2)
                    .padding()
            }

            // Game Grid
            Grid(gridSize: gridSize, items: colors) { index, color in
                Rectangle()
                    .fill(color)
                    .frame(width: 100, height: 100)
                    .onTapGesture {
                        startTimerIfNeeded()
                        handleTap(index: index)
                    }
                    .overlay(
                        selectedIndices.contains(index) ?
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 3) :
                            nil
                    )
            }
            .padding()
            .onAppear(perform: loadColors)

            // Restart Button
            Button("Restart") {
                restartGame()
            }
            .padding()
            .font(.headline)
            .buttonStyle(.borderedProminent)
        }
        .alert(isPresented: $showGameOverAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Your score is \(score)."),
                primaryButton: .default(Text("Play Again")) {
                    restartGame()
                },
                secondaryButton: .default(Text("Main Menu")) {
                    showMainMenu = true
                }
            )
        }
        .onReceive(Timer.publish(every: timerInterval, on: .main, in: .common).autoconnect()) { _ in
            updateTimer()
        }
        .fullScreenCover(isPresented: $showMainMenu) {
            ContentView()
        }
    }

    // Timer Update Logic
    private func updateTimer() {
        if isTimerRunning && timeRemaining > 0 {
            timeRemaining -= 1
        } else if timeRemaining == 0 {
            endGame()
        }
    }

    // Handle Timer Start
    private func startTimerIfNeeded() {
        if !isTimerRunning {
            isTimerRunning = true
        }
    }

    // End Game Logic
    private func endGame() {
        isTimerRunning = false
        showGameOverAlert = true
        isGameOver = true
    }

    // Restart Game Logic
    private func restartGame() {
        timeRemaining = 30
        score = 0
        selectedIndices.removeAll()
        loadColors()
        isTimerRunning = false
        isGameOver = false
    }

    // Load Random Colors
    private func loadColors() {
        let allColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]
        colors = (0..<(gridSize * gridSize))
            .map { _ in allColors.randomElement() ?? .gray }
    }

    private func handleTap(index: Int) {
        if selectedIndices.contains(index) {
            // Undo selection if the tile is already selected
            selectedIndices.removeAll { $0 == index }
            return
        }

        selectedIndices.append(index)

        if selectedIndices.count == 2 {
            let firstIndex = selectedIndices[0]
            let secondIndex = selectedIndices[1]

            if colors[firstIndex] == colors[secondIndex] {
                score += 1

                colors[firstIndex] = randomColor()
                colors[secondIndex] = randomColor()
            } else {
                endGame() // End game if colors don't match
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedIndices.removeAll()
            }
        }
    }

    private func randomColor() -> Color {
        let allColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]
        return allColors.randomElement() ?? .gray
    }

    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%01d:%02d", minutes, seconds)
    }
}

struct Grid<Content: View>: View {
    let gridSize: Int
    let items: [Color]
    let content: (Int, Color) -> Content

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: gridSize)) {
            ForEach(0..<items.count, id: \..self) { index in
                content(index, items[index])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
