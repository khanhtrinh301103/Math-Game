import SwiftUI
import AVFoundation

struct SavedScoreView: View {
    @Binding var savedScores: [Score]
    @Binding var showSavedScores: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var resumeTimer: () -> Void // Add this callback
    
    var body: some View {
        NavigationView {
            List(savedScores) { score in
                VStack(alignment: .leading) {
                    Text("Username:")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text(score.username)
                        .font(.body)
                    
                    Text("Score:")
                        .font(.headline)
                        .foregroundColor(.green)
                    Text("\(score.value)")
                        .font(.body)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow.opacity(0.5)))
                .padding(.vertical, 4)
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Leaderboard", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showSavedScores.toggle()
                resumeTimer() // Call the callback to resume the timer
                
                // Play the sound when the "Close" button is tapped
                playSound(sound: "Button", type: "mp3")
            }) {
                Text("Close")
                    .font(.headline)
            })
        }
        .onAppear{playSound(sound: "Leaderboard", type: "mp3")}
        .onDisappear {
            resumeTimer() // Resume the timer when leaving the view
        }
        .background(
            LinearGradient(
            gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).ignoresSafeArea(.all, edges: .all))
    }
}

struct SavedScoreView_Previews: PreviewProvider {
    static var previews: some View {
        SavedScoreView(savedScores: .constant([]), showSavedScores: .constant(true), resumeTimer: {})
    }
}
