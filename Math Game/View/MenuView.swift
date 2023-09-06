import SwiftUI

struct MenuView: View {
    @Binding var active: Bool
    @Binding var isShowingSettings: Bool
    @Binding var selectedDifficulty: GameDifficulty
    @State private var isShowingInstructions: Bool = false // Declare isShowingInstructions
    @AppStorage("isDarkMode") private var isDarkMode = false // Track the color theme
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
    
    var body: some View {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea(.all, edges: .all)
                
                
                VStack(spacing: 20) {
                    Spacer()
                    VStack(spacing: 0) {
                        Image("logo")
                            .resizable()
                            .frame(width: 200, height: 150)
                            .foregroundColor(.white)
                        
                        Text("Math Game")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                            .onAppear{
                                playSound(sound: "Menu", type: "mp3")
                            }
                    }
                    Spacer()
                    
                    Button(action: {
                        active = false
                        self.button()
                    }, label: {
                        Capsule()
                            .fill(Color.white.opacity(0.8))
                            .padding(8)
                            .frame(height: 80)
                            .overlay(Text("Let's play ▶︎")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color.blue))
                    })
                    
                    Button(action: {
                        isShowingInstructions.toggle() // Toggle the state of isShowingInstructions
                        self.button()
                    }, label: {
                        Capsule()
                            .fill(Color.white.opacity(0.8))
                            .padding(8)
                            .frame(height: 80)
                            .overlay(Text("How to Play 💡")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color.orange))
                    })
                    .sheet(isPresented: $isShowingInstructions) {
                        InstructionView(isShowingInstruction: $isShowingInstructions) // Pass isShowingInstructions
                    }
                    
                    
                    Button(action: {
                        isShowingSettings.toggle()
                        self.button()
                    }, label: {
                        Capsule()
                            .fill(Color.white.opacity(0.8))
                            .padding(8)
                            .frame(height: 80)
                            .overlay(Text("Settings ⚙️")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(Color.red))
                    })
                    .sheet(isPresented: $isShowingSettings) {
                        GameSettingView(isShowingSettings: $isShowingSettings, selectedDifficulty: $selectedDifficulty) // Pass selectedDifficulty
                    }
                    
                    
                    
                    
                    Button(action: {
                        isDarkMode.toggle()
                        self.button()
                    }) {
                        Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .offset(x: 0, y: 20) // Position the button in the top-left corner
                    }
                    .padding(.leading, 10) // Add some additional padding for better spacing
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the color scheme
        }
    }
    

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(active: .constant(true), isShowingSettings: .constant(false), selectedDifficulty: .constant(.easy))
    }
}
