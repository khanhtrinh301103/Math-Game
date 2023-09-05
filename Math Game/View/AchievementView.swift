import SwiftUI

struct AchievementView: View {
    @Binding var isPresented: Bool
    @Binding var coins: Int
    @Binding var score: Int
    @Binding var claimedAchievements: Set<String> // Track claimed achievements

    var body: some View {
        NavigationView {
            List {
                AchievementRow(title: "Score 10", description: "Claim 10 coins", condition: score >= 10, reward: 10, isClaimed: claimedAchievements.contains("Score 10")) { claimed in
                    if claimed {
                        claimedAchievements.insert("Score 10")
                        coins += 10 // Claim the reward
                    }
                }
                AchievementRow(title: "Score 50", description: "Claim 20 coins", condition: score >= 50, reward: 20, isClaimed: claimedAchievements.contains("Score 50")) { claimed in
                    if claimed {
                        claimedAchievements.insert("Score 50")
                        coins += 20 // Claim the reward
                    }
                }
                AchievementRow(title: "Score 100", description: "Claim 50 coins", condition: score >= 100, reward: 50, isClaimed: claimedAchievements.contains("Score 100")) { claimed in
                    if claimed {
                        claimedAchievements.insert("Score 100")
                        coins += 50 // Claim the reward
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Achievements")
            .navigationBarItems(trailing: Button(action: {
                isPresented = false
            }) {
                Text("Close")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AchievementRow: View {
    let title: String
    let description: String
    let condition: Bool
    let reward: Int
    let isClaimed: Bool
    let claimAction: (Bool) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
            }
            Spacer()
            if condition {
                if isClaimed {
                    Text("Claimed")
                        .foregroundColor(.green)
                } else {
                    Button(action: {
                        claimAction(true)
                    }) {
                        Text("Claim \(reward) Coins")
                            .foregroundColor(.blue)
                    }
                }
            } else {
                Text("Locked")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView(isPresented: .constant(true), coins: .constant(50), score: .constant(100), claimedAchievements: .constant([]))
    }
}

