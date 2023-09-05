import SwiftUI

struct GameOverView: View {
    @Binding var isGameOver: Bool
    @Binding var score: Int
    @Binding var username: String
    var restartGame: () -> Void // Add this closure
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .opacity(isGameOver ? 1 : 0) // Fade-in animation
                    .onAppear{
                        playSound(sound: "GameOver", type: "mp3")
                        
                    }
                Image(systemName: "gamecontroller.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .scaleEffect(isGameOver ? 1 : 0.5) // Scale-in animation
                    .opacity(isGameOver ? 1 : 0) // Fade-in animation
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isGameOver = true
                        }
                    }

                Text("Username: \(username)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(isGameOver ? 1 : 0) // Fade-in animation
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isGameOver = true
                        }
                    }

                Text("Score: \(score)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .opacity(isGameOver ? 1 : 0) // Fade-in animation
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isGameOver = true
                        }
                    }

                Button(action: {
                    self.button()
                    isGameOver = false
                    restartGame() // Call the restartGame closure
                }) {
                    Text("Play Again")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .opacity(isGameOver ? 1 : 0) // Fade-in animation
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isGameOver = true
                    }
                }
            }
        }
    }
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
    
}



struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(isGameOver: .constant(true), score: .constant(10), username: .constant("Player"), restartGame: {})
    }
}

