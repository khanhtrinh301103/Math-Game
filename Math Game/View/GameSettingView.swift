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

struct GameSettingView: View {
    @Binding var isShowingSettings: Bool
    @Binding var selectedDifficulty: GameDifficulty
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack {
            Text("Select Difficulty Level")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 20)

            // Button to select Easy difficulty
            Button("Easy: Addition", action: {
                self.button()
                selectedDifficulty = .easy // Set the selected difficulty to Easy
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .easy ? Color.green : Color.gray) // Highlight if selected
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            // Button to select Medium difficulty
            Button("Medium: Multiplication", action: {
                self.button()
                selectedDifficulty = .medium // Set the selected difficulty to Medium
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .medium ? Color.orange : Color.gray) // Highlight if selected
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            // Button to select Hard difficulty
            Button("Hard: Addition and Division", action: {
                self.button()
                selectedDifficulty = .hard // Set the selected difficulty to Hard
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .hard ? Color.red : Color.gray) // Highlight if selected
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            // Button to save the selected difficulty and close the settings view
            Button("Save", action: {
                self.button()
                isShowingSettings = false // Close the settings view
            })
            .font(.headline)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
        )
        .cornerRadius(20)
        .padding(20)
    }
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
}

struct GameSettingView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingView(isShowingSettings: .constant(true), selectedDifficulty: .constant(.easy))
    }
}
