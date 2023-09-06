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

// Define a struct called Score, which conforms to the Identifiable protocol
struct Score: Identifiable {
    
    // Create a unique identifier for each Score instance using UUID
    let id = UUID()
    
    // Store the username associated with the score as a String
    let username: String
    
    // Store the numerical value of the score as an Int
    let value: Int
}
