import SwiftUI

struct AnswerButton: View {
    var number: Int
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        Text("\(number)")
            .frame(width: 110, height: 110)
            .font(.system(size: 40, weight: .bold))
            .foregroundColor(Color.white)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode ? [Color.black, Color.yellow] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea(.all, edges: .all)
            )
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
            .padding()
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(number: 100)
    }
}
