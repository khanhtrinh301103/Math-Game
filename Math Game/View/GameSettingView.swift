import SwiftUI

struct GameSettingView: View {
    @Binding var isShowingSettings: Bool
    @Binding var selectedDifficulty: GameDifficulty

    var body: some View {
        VStack {
            Text("Select Difficulty Level")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 20)

            Button("Easy: Addition", action: {
                self.button()
                selectedDifficulty = .easy
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .easy ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            Button("Medium: Multiplication", action: {
                self.button()
                selectedDifficulty = .medium
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .medium ? Color.orange : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            Button("Hard: Addition and Division", action: {
                self.button()
                selectedDifficulty = .hard
            })
            .font(.headline)
            .padding()
            .background(selectedDifficulty == .hard ? Color.red : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.bottom, 10)

            // Add a button to save the selected difficulty
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
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.purple, Color.blue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
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

