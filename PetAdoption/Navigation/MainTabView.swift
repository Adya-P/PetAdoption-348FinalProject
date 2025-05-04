//
//  MainTabView.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/31/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Pets", systemImage: "pawprint")
                }
            
            SheltersView()
                .tabItem {
                    Label("Shelters", systemImage: "house")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

#Preview {
    MainTabView()
}
