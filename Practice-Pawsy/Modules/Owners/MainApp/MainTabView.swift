import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            RemindersView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Reminders")
                }
            
            BookingView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Booking")
                }
            
            SOSView()
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
