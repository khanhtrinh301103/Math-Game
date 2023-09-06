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

import AVFoundation

var audioPlayer: AVAudioPlayer?

// Function to play a sound with a specified filename and file type (e.g., "sound", "mp3")
func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            // Create an AVAudioPlayer with the sound file URL
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            // Play the audio
            audioPlayer?.play()
        } catch {
            // Handle any errors that occur during audio playback
            print("ERROR: Could not find and play the sound file!")
        }
    }
}

// Function to stop the currently playing background sound
func stopBackgroundSound() {
    audioPlayer?.stop()
}
