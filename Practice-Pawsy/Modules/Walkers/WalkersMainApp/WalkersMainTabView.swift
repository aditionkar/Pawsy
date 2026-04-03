//
//  WalkersMainTabView.swift
//  Practice-Pawsy
//
//  Created by user@37 on 03/04/26.
//

import SwiftUI

struct WalkersMainTabView: View {
    var body: some View {
        TabView {
            
            // REQUESTS
            RequestsView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("Requests")
                }
            
            // MY JOBS
            MyJobsView()
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("My Jobs")
                }
            
            // PROFILE
            WalkersProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .tint(.orange) 
    }
}

#Preview {
    WalkersMainTabView()
}
