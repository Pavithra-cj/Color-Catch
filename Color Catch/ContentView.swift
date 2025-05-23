//
//  ContentView.swift
//  Color Catch
//
//  Created by Pavithra Chamod on 2025-01-25.
//

import SwiftUI

struct ContentView: View {
    @State private var showInstructions = false
    @State private var showQuitConfirmation = false

    var body: some View {
        NavigationView {
                    VStack(spacing: 20) {
                        Text("Color catch")
                            .font(.largeTitle)
                            .padding()

                        NavigationLink(destination: GameView()) {
                            Text("Play")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            showInstructions.toggle()
                        }) {
                            Text("Instructions")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented:$showInstructions) {
                            InstructionsView(showInstructions:$showInstructions)
                        }

                        Button(action: {
                            showQuitConfirmation.toggle()
                        }) {
                            Text("Quit")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showQuitConfirmation) {
                            Alert(
                                title: Text("Quit Game"),
                                message: Text("Are you sure you want to quit?"),
                                primaryButton: .destructive(Text("Quit")) {
                                    exit(0)
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    .padding()
                }
    }
}

#Preview {
    ContentView()
}
