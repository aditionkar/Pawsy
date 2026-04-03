import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            Text("Home Screen")
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            RemindersView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Reminders")
                }
            
            Text("Walks Screen")
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Walks")
                }
            
            Text("SOS Screen")
                .tabItem {
                    Image(systemName: "star")
                    Text("SOS")
                }
        }
        .tint(.orange) 
    }
}

#Preview {
    MainTabView()
}
