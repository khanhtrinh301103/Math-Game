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

// InstructionView displays instructions on how to play the game.
struct InstructionView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var isShowingInstruction: Bool // Binding variable to control view visibility
    
    var body: some View {
        ZStack {
            // Background gradient based on isDarkMode
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ? [Color.black, Color.yellow] : [Color.yellow, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.button()
                            isShowingInstruction = false // Close the view when the button is tapped
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                        }
                        .padding(20)
                    }
                    
                    Text("How to Play Math Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .foregroundColor(Color.white) // Title text color
                    
                    // Step 1 instructions
                    StepView(stepNumber: "1", titleKey: "Choose a Difficulty Level", descriptionKey: "In the settings, select your preferred difficulty level: Easy, Medium, or Hard", backgroundColor: Color.yellow)
                    
                    Image("Welcome")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    // Step 2 instructions
                    StepView(stepNumber: "2", titleKey: "Start the Game", descriptionKey: "After selecting a difficulty level, tap Save button to save the level of difficulty then tap let's play to begin.", backgroundColor: Color.purple)
                    
                    Image("Setting")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    // Step 3 instructions
                    StepView(stepNumber: "3", titleKey: "Answer the Questions and saved score", descriptionKey: "You will be presented with math questions based on your chosen difficulty. Tap the correct answer to earn score, you have 10 seconds for each question. When you save the score, this game will encourage you by a winning screen and notify that your score is saved successfully, you can check the save score by tapping the button view saved scores", backgroundColor: Color.blue)
                    
                    Image("GameView")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    // Step 4 instructions
                    StepView(stepNumber: "4", titleKey: "Game Over view", descriptionKey: "When your score is below 0 or the time is up, the game will be overed", backgroundColor: Color.yellow)
                    
                    Image("GameOver")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                }
                .padding()
            }
            .background(Color.clear) // Clear the background of the ZStack
        }
    }
    
    // Play a button sound
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
}

// StepView displays a single step of instructions.
struct StepView: View {
    var stepNumber: String
    var titleKey: String  // Use String for the keys
    var descriptionKey: String  // Use String for the keys
    var backgroundColor: Color
    
    var title: LocalizedStringKey { LocalizedStringKey(titleKey) } // Computed property for localized title
    var description: LocalizedStringKey { LocalizedStringKey(descriptionKey) } // Computed property for localized description
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(stepNumber)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .padding(10)
                    .background(backgroundColor)
                    .cornerRadius(20)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .padding(.leading, 10)
            }
            
            Text(description)
                .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .background(backgroundColor.opacity(0.7))
        .cornerRadius(10)
    }
}



// PreviewProvider for InstructionView
struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(isShowingInstruction: .constant(true))
    }
}
