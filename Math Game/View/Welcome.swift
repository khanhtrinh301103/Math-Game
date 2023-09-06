/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Trinh Xuan Khanh
  ID: s3927152
  Created  date: 29/08/2023
  Last modified: 06/09/2023
  Acknowledgement: None.
*/

import SwiftUI

struct Welcome: View {
    @State private var isWelcomeActive: Bool = true
    @State private var isShowingSettings: Bool = false
    @State private var selectedDifficulty: GameDifficulty = .easy

    var body: some View {
        ZStack {
            if isWelcomeActive {
                // Show MenuView if isWelcomeActive is true
                MenuView(active: $isWelcomeActive, isShowingSettings: $isShowingSettings, selectedDifficulty: $selectedDifficulty)
            } else {
                // Show GameView if isWelcomeActive is false
                GameView(selectedDifficulty: $selectedDifficulty, isWelcomeActive: $isWelcomeActive)
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            // Show GameSettingView as a sheet when isShowingSettings is true
            GameSettingView(isShowingSettings: $isShowingSettings, selectedDifficulty: $selectedDifficulty)
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
