import SwiftUI

struct InstructionView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Binding var isShowingInstruction: Bool // Add a binding variable to control the view's visibility
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.button()
                            isShowingInstruction = false // Set the binding variable to false to close the view
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
                        .foregroundColor(Color.white) // Change the title text color
                        .onAppear{
                            playSound(sound: "HowToPlay", type: "mp3")
                            
                        }
                    
                    StepView(stepNumber: "1", title: "Choose a Difficulty Level", description: "In the settings, select your preferred difficulty level: Easy, Medium, or Hard", backgroundColor: Color.yellow)
                    
                    Image("Welcome")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    StepView(stepNumber: "2", title: "Start the Game", description: "After selecting a difficulty level, tap Save button to save the level of difficulty then tap let's play to begin.", backgroundColor: Color.purple)
                    
                    Image("Setting")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    StepView(stepNumber: "3", title: "Answer the Questions and saved score", description: "You will be presented with math questions based on your chosen difficulty. Tap the correct answer to earn score, you have 10 seconds for each question. When you save the score, this game will encourage you by a winning screen and notify that your score is saved successfully, you can check the save score by tapping the button view saved scores", backgroundColor: Color.blue)
                    
                    Image("GameView")
                        .resizable()
                        .frame(width: 300, height: 600)
                        .foregroundColor(.white)
                    
                    StepView(stepNumber: "4", title: "Game Over view", description: "When your score is below 0 or the time is up, the game will be overed", backgroundColor: Color.yellow)
                    
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
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
}

struct StepView: View {
    var stepNumber: String
    var title: String
    var description: String
    var backgroundColor: Color
    
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

struct InstructionView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionView(isShowingInstruction: .constant(true))
    }
}
