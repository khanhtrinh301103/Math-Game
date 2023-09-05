import SwiftUI

struct Welcome: View {
    @State private var isWelcomeActive: Bool = true
    @State private var isShowingSettings: Bool = false
    @State private var selectedDifficulty: GameDifficulty = .easy

    var body: some View {
        ZStack {
            if isWelcomeActive {
                MenuView(active: $isWelcomeActive, isShowingSettings: $isShowingSettings, selectedDifficulty: $selectedDifficulty)
            } else {
                GameView(selectedDifficulty: $selectedDifficulty, isWelcomeActive: $isWelcomeActive)
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            GameSettingView(isShowingSettings: $isShowingSettings, selectedDifficulty: $selectedDifficulty)
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
