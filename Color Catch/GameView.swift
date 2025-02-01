//
//  GameView.swift
//  Color Catch
//
//  Created by Pavithra Chamod on 2025-01-25.
//

import SwiftUI

struct GameView: View {
    let gridSize: Int
    let timerInterval = 1.0
    
    @State private var colors: [Color] = []
    @State private var selectedIndices: [Int] = []
    @State private var disabledIndices: Set<Int> = []
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 30
    @State private var isTimerRunning = false
    @State private var showGameOverAlert = false
    @State private var showMainMenu = false
    @State private var stage: Int = 1
    
    private let availableColors: [Color] = [
        .red,
        .green,
        .blue,
        .yellow,
        .orange,
        .purple,
        .pink,
        .cyan,
        .brown,
        .indigo,
        .teal,
        .accentColor
    ]
    
    var body: some View {
        VStack {
            HStack {
                Text("Time: \(formatTime(timeRemaining))")
                    .font(.title2)
                    .padding()
                Spacer()
                Text("Score: \(score)")
                    .font(.title2)
                    .padding()
            }
            
            Grid(gridSize: gridSize, items: colors) { index, color in
                Rectangle()
                    .fill(color)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .opacity(disabledIndices.contains(index) ? 0.2 : 1.0)
                    .overlay(
                        selectedIndices.contains(index) ?
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 3) :
                            nil
                    )
                    .onTapGesture {
                        if !disabledIndices.contains(index) {
                            startTimerIfNeeded()
                            handleTap(index: index)
                        }
                    }
            }
            .padding()
            .onAppear(perform: setupBoard)
            
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
    
    private func updateTimer() {
        if isTimerRunning && timeRemaining > 0 {
            timeRemaining -= 1
        } else if timeRemaining == 0 {
            showGameOverAlert = true
            isTimerRunning = false
        }
    }
    
    private func startTimerIfNeeded() {
        if !isTimerRunning {
            isTimerRunning = true
        }
    }
    
    private func restartGame() {
        timeRemaining = 30
        score = 0
        stage = 1
        selectedIndices.removeAll()
        disabledIndices.removeAll()
        setupBoard()
        isTimerRunning = false
    }
    
    private func setupBoard() {
    let totalTiles = gridSize * gridSize
    var colorPairs: [Color] = []

    let pairsNeeded = totalTiles / 2

    let selectedColors = availableColors.shuffled().prefix(pairsNeeded)
    for color in selectedColors {
        colorPairs.append(color)
        colorPairs.append(color)
    }

    while colorPairs.count < totalTiles {
        colorPairs.append(.gray)
    }

    colors = colorPairs.shuffled()
    selectedIndices.removeAll()
    disabledIndices.removeAll()
}
    
    private func handleTap(index: Int) {
        if selectedIndices.contains(index) {
            selectedIndices.removeAll { $0 == index }
            return
        }
        
        selectedIndices.append(index)
        
        if selectedIndices.count == 2 {
            let firstIndex = selectedIndices[0]
            let secondIndex = selectedIndices[1]
            
            if colors[firstIndex] == colors[secondIndex] {
                score += 1
                disabledIndices.insert(firstIndex)
                disabledIndices.insert(secondIndex)
                
                if disabledIndices.count == colors.count || colors.count - disabledIndices.count == 1 {
                    stage += 1
                    timeRemaining = max(5, timeRemaining - 5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        setupBoard()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedIndices.removeAll()
            }
        }
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
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: gridSize),
            spacing: 2
        ) {
            ForEach(0..<items.count, id: \ .self) { index in
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
