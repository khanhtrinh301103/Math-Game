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

import Foundation

// Define an enumeration called DifficultyLevel
enum DifficultyLevel: String, CaseIterable {
    
    // Define three cases: easy, medium, and hard, with associated String values
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    // CaseIterable protocol conformance allows you to iterate through all cases
    // This is useful for generating a list of difficulty levels in your code
}
