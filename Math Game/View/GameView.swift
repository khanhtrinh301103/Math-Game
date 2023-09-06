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

// GameView represents the main game screen
struct GameView: View {
    // State variables to manage various aspects of the game
    @State private var showSavedScores = false
    @State private var correctAnswer = 0
    @State private var choiceArray: [Int] = [0, 1, 2, 3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var thirdNumber = 0
    @State private var difficulty = 100
    @State private var score = 0
    @State private var isVietnamese: Bool = false // Track the selected language
    @State private var isGameOver = false
    @State private var savedScores: [Score] = []
    @State private var username = ""
    @State private var isEnteringUsername = true
    @Binding var selectedDifficulty: GameDifficulty
    @Binding var isWelcomeActive: Bool
    @State private var isWinAchievementViewPresented = false
    private let originalTimeLimit = 10
    
    // Timer and time-related state variables
    @State private var timer: Timer?
    @State private var timeRemaining = 10
    @State private var isTimerPaused = false
    
    // Dark mode setting
    @AppStorage("isDarkMode") private var isDarkMode = false

    // Define the color scheme based on dark mode setting
    private var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea(.all, edges: .all)
            
            // Check if entering username
            if !isEnteringUsername {
                // Game screen UI elements
                LinearGradient(
                    gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea(.all, edges: .all)
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 0)
                    .frame(width: 350, height: 650)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: isDarkMode ? [Color.black, Color.white] : [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ).ignoresSafeArea(.all, edges: .all)
                    )
            }
            
            VStack {
                if isEnteringUsername {
                    // Username entry view
                    UsernameEntryView(username: $username, onUsernameEntered: startGame)
                        .foregroundColor(.yellow)
                } else {
                    if isGameOver {
                        // Game over view
                        GameOverView(isGameOver: $isGameOver, score: $score, username: $username, restartGame: restartGame)
                    } else {
                        // Display the current math question based on selected difficulty
                        Text(selectedDifficulty == .easy ? "\(firstNumber) + \(secondNumber)" : selectedDifficulty == .medium ? "\(firstNumber) * \(secondNumber)" : "(\(firstNumber) + \(secondNumber)) : \(thirdNumber)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        // Answer buttons
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
                        
                        // Display score and time remaining
                        Text("Score: \(score)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("Time Remaining: \(timeRemaining)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                        
                        // Save score button
                        Button(action: {
                            self.button()
                            if score >= 0 {
                                saveScore()
                                isWinAchievementViewPresented = true
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
                        
                        // View saved scores button
                        Button(action: {
                            self.button()
                            showSavedScores.toggle()
                            pauseTimer()
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
                        
                        // Return to welcome screen button
                        Button(action: {
                            self.button()
                            isWelcomeActive = true
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
            startTimer()
        }
        .onAppear(perform: {
          playSound(sound: "GameView", type: "mp3")
        })
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    // Start the game timer
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
    
    // Check if the selected answer is correct
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
    
    // Generate new math questions based on difficulty level
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
    
    // Generate addition questions
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
    
    // Generate multiplication questions
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
    
    // Generate division questions
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
    
    // Restart the game
    func restartGame() {
        score = 0
        isGameOver = false
        timeRemaining = 10 // Reset the timer
        generateAnswers()
        startTimer() // Start the timer again
    }
    
    // Start the game when the username is entered
    func startGame() {
        isEnteringUsername = false
        generateAnswers()
        startTimer()
    }
    
    // Pause the game timer
    func pauseTimer() {
        isTimerPaused = true
    }

    // Save the user's score
    func saveScore() {
        // Pause the timer when saving the score
        isTimerPaused = true
        
        savedScores.append(Score(username: username, value: score))
        // You can also add additional logic here, such as sorting the savedScores array.
    }
    
    // Resume the game timer
    func resumeTimer() {
        isTimerPaused = false // Unpause the timer
    }
    
    // Play a button sound
    func button(){
        playSound(sound: "Button", type: "mp3")
    }
}

// UsernameEntryView is responsible for username input
struct UsernameEntryView: View {
    @Binding var username: String
    let onUsernameEntered: () -> Void
    @State private var isVietnamese: Bool = false // Track the selected language
    
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
    
    // Play a button sound
    func StartButton(){
        playSound(sound: "Button", type: "mp3")
    }
}

// PreviewProvider for GameView
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let isWelcomeActiveBinding = Binding<Bool>(
            get: { false }, // You can set this to true or false depending on your needs
            set: { _ in }
        )
        return GameView(selectedDifficulty: .constant(.easy), isWelcomeActive: isWelcomeActiveBinding)
    }
}
