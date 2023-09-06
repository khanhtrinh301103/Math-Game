import SwiftUI

struct GameView: View {
    @State private var showSavedScores = false
    @State private var correctAnswer = 0
    @State private var choiceArray: [Int] = [0, 1, 2, 3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var thirdNumber = 0
    @State private var difficulty = 100
    @State private var score = 0
    @State private var isGameOver = false
    @State private var savedScores: [Score] = []
    @State private var username = ""
    @State private var isEnteringUsername = true
    @Binding var selectedDifficulty: GameDifficulty
    @Binding var isWelcomeActive: Bool
    @State private var isWinAchievementViewPresented = false
    private let originalTimeLimit = 10
    
    @State private var timer: Timer?
    @State private var timeRemaining = 10 // Initial time limit
    @State private var isTimerPaused = false // Flag to indicate timer pause state
    @AppStorage("isDarkMode") private var isDarkMode = false

    private var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }

    
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
            if !isEnteringUsername {
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea(.all, edges: .all)
                RoundedRectangle(cornerRadius: 20) // Adjust the corner radius as needed
                    .stroke(Color.white, lineWidth: 0) // Customize the border color and width
                    .frame(width: 350, height: 650) // Adjust the width and height as needed
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]), // Change colors based on isDarkMode
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).ignoresSafeArea(.all, edges: .all)
                    )
            }
            
            VStack {
                if isEnteringUsername {
                    // Prompt the user to enter a username
                    UsernameEntryView(username: $username, onUsernameEntered: startGame)
                        .foregroundColor(.yellow)
                } else {
                    if isGameOver {
                        // Game Over view here
                        GameOverView(isGameOver: $isGameOver, score: $score, username: $username, restartGame: restartGame)
                    } else {
                        Text(selectedDifficulty == .easy ? "\(firstNumber) + \(secondNumber)" : selectedDifficulty == .medium ? "\(firstNumber) * \(secondNumber)" : "(\(firstNumber) + \(secondNumber)) : \(thirdNumber)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        HStack {
                            ForEach(0..<2) { index in
                                Button {
                                    self.button()
                                    if !isGameOver {
                                        answerIsCorrect(answer: choiceArray[index])
                                        generateAnswers()
                                    }
                                } label: {
                                    AnswerButton(number: choiceArray[index])
                                }
                                .disabled(isGameOver)
                            }
                        }
                        
                        HStack {
                            ForEach(2..<4) { index in
                                Button {
                                    self.button()
                                    if !isGameOver {
                                        answerIsCorrect(answer: choiceArray[index])
                                        generateAnswers()
                                    }
                                } label: {
                                    AnswerButton(number: choiceArray[index])
                                }
                                .disabled(isGameOver)
                            }
                        }
                        
                        Text("Score \(score)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Time Remaining: \(timeRemaining)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .onAppear{playSound(sound: "GameView", type: "mp3")}
                        
                        Button(action: {
                            self.button()
                            if score >= 0 {
                                saveScore()
                                isWinAchievementViewPresented = true // Show the WinAchievementView
                            } else {
                                isGameOver = true
                                audioPlayer?.stop()
                            }
                        }) {
                            Text("Save Score")
                                .font(.headline)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(isGameOver)
                        .sheet(isPresented: $isWinAchievementViewPresented) {
                            WinAchievementView(isPresented: $isWinAchievementViewPresented, resumeTimer: resumeTimer)
                        }
                        
                        Button(action: {
                            self.button()
                            showSavedScores.toggle()
                            pauseTimer() // Call the function to pause the timer
                        }) {
                            Text("View Saved Scores")
                                .font(.headline)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showSavedScores) {
                            SavedScoreView(savedScores: $savedScores, showSavedScores: $showSavedScores,  resumeTimer: resumeTimer)
                        }
                        
                        Button(action: {
                            self.button()
                            isWelcomeActive = true // Call the function to pause the timer
                        }) {
                            Text("Return")
                                .font(.headline)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(colorScheme)
        .onAppear {
            // Start the timer when the view appears
            startTimer()
        }
        .onAppear(perform: {
          playSound(sound: "GameView", type: "mp3")
        })
        .onDisappear {
            // Invalidate the timer when the view disappears
            timer?.invalidate()
        }
    }
    
    func startTimer() {
        timer?.invalidate() // Invalidate any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !isTimerPaused {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Time is up, end the game
                    timer.invalidate()
                    isGameOver = true
                }
            }
        }
        
        // Ensure the timer fires immediately when started
        timer?.fire()
    }
    
    
    func answerIsCorrect(answer: Int) {
        let isCorrect = answer == correctAnswer ? true : false
        
        if isCorrect {
            self.score += 1
        } else {
            self.score -= 1
        }
        
        if score < 0 {
            isGameOver = true
            audioPlayer?.stop()
        }
    }
    
    func generateAnswers() {
        switch selectedDifficulty {
        case .easy:
            generateSumAnswers()
        case .medium:
            generateProductAnswers()
        case .hard:
            generateDivisionAnswers()
        }
        
        // Reset the timer to the original time limit when generating new answers
        timeRemaining = originalTimeLimit
        startTimer()
    }
    
    
    func generateSumAnswers() {
        firstNumber = Int.random(in: 0...(difficulty / 2))
        secondNumber = Int.random(in: 0...(difficulty / 2))
        var answerList = [Int]()
        
        correctAnswer = firstNumber + secondNumber
        
        for i in 0...2 {
            answerList.append(Int.random(in: 0...difficulty))
        }
        answerList.append(correctAnswer)
        
        choiceArray = answerList.shuffled()
    }
    
    func generateProductAnswers() {
        firstNumber = Int.random(in: 10...99)
        secondNumber = Int.random(in: 1...20)
        
        correctAnswer = firstNumber * secondNumber
        
        var answerList = [Int]()
        
        for i in 0...2 {
            answerList.append(Int.random(in: 1...1000)) // You can adjust the range as needed.
        }
        answerList.append(correctAnswer)
        
        choiceArray = answerList.shuffled()
    }
    
    func generateDivisionAnswers() {
        var sum = 0
        var isSumDivisible = false
        
        while !isSumDivisible {
            firstNumber = Int.random(in: 10...99)
            secondNumber = Int.random(in: 0...100)
            thirdNumber = Int.random(in: 1...10)
            
            sum = firstNumber + secondNumber
            
            if sum % thirdNumber == 0 {
                isSumDivisible = true
            }
        }
        
        correctAnswer = sum / thirdNumber
        
        var answerList = [Int]()
        
        for _ in 0...2 {
            answerList.append(Int.random(in: 0...200))
        }
        answerList.append(correctAnswer)
        
        choiceArray = answerList.shuffled()
    }
    
    func restartGame() {
        score = 0
        isGameOver = false
        timeRemaining = 10 // Reset the timer
        generateAnswers()
        startTimer() // Start the timer again
    }
    
    
    func startGame() {
        // Called when the user enters a username and starts the game
        isEnteringUsername = false
        generateAnswers()
        startTimer()
    }
    
    func pauseTimer() {
        isTimerPaused = true
    }

    
    func saveScore() {
        // Pause the timer when saving the score
        isTimerPaused = true
        
        savedScores.append(Score(username: username, value: score))
        // You can also add additional logic here, such as sorting the savedScores array.
    }
    
    func resumeTimer() {
        isTimerPaused = false // Unpause the timer
    }
    
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
    
    
}

struct UsernameEntryView: View {
    @Binding var username: String
    let onUsernameEntered: () -> Void
    
    var body: some View {
        VStack {
            Text("Enter Your Username:")
                .font(.headline)
                .padding(.bottom, 20)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        
        Button("Start Game", action: {
            self.StartButton()
            if !username.isEmpty {
                onUsernameEntered()
            }
        })
        .font(.headline)
        .padding()
        .background(Color.green)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    func StartButton(){
        playSound(sound: "Button", type: "mp3")
    }
    
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let isWelcomeActiveBinding = Binding<Bool>(
            get: { false }, // You can set this to true or false depending on your needs
            set: { _ in }
        )
        return GameView(selectedDifficulty: .constant(.easy), isWelcomeActive: isWelcomeActiveBinding)
    }
}
