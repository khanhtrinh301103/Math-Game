import SwiftUI

struct WinAchievementView: View {
    @Binding var isPresented: Bool
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1
    var resumeTimer: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.red, Color.blue]), // Customize your gradient colors
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).edgesIgnoringSafeArea(.all)

            VStack {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 30)
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            scale = 1.2
                        }
                        
                        playSound(sound: "Won", type: "mp3")
                        
                    }

                Image(systemName: "star.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .rotationEffect(.degrees(rotation))
                    .onAppear {
                        withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                    }

                Text("You Won the Game!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.yellow)
                    .padding(.top, 20)
                
                Text("Your score is saved successfully")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.top, 20)

                Button(action: {
                    self.button()
                    isPresented.toggle()
                    resumeTimer()
                    stopBackgroundSound()
                }) {
                    Text("Close")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(50)
                }
                .padding(.top, 30)
            }
            .padding(30)
            .background(Color.clear) // Make the background clear so that the gradient shows through
            .cornerRadius(20)
        }
    }
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
}


struct WinAchievementView_Previews: PreviewProvider {
    static var previews: some View {
        WinAchievementView(isPresented: .constant(true), resumeTimer: {})
    }
}
