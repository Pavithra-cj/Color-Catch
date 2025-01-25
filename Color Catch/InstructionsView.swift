//
//  InstructionsView.swift
//  Color Catch
//
//  Created by Pavithra Chamod on 2025-01-25.
//

import SwiftUI

struct InstructionsView: View {
    @Binding var showInstructions: Bool

    var body: some View {
        VStack {
            Text("Instructions")
                .font(.largeTitle)
                .padding()

            Text("Here are the instructions on how to play the game.")
                .font(.body)
                .padding()

            Spacer()

            Button(action: {
                showInstructions = false
            }) {
                Text("Close")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}
