//
//  ProfileView.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/31/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var user: User? = nil

    var body: some View {
        NavigationView {
            VStack {
                if let user = user {
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                        
                        Text(user.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: logout) {
                            Text("Log Out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding()
                    }
                    .padding()
                } else {
                    ProgressView("Loading Profile...")
                        .onAppear {
                            fetchUser()
                        }
                }
            }
            .navigationTitle("Profile")
        }
    }
    
    private func fetchUser() {
        // Replace with actual user fetch logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.user = User(id: 1, name: "John Doe", email: "john.doe@example.com")
        }
    }
    
    private func logout() {
        // Implement logout functionality here
        print("User logged out")
    }
}

//// Sample User Model
//struct User {
//    let id: Int
//    let name: String
//    let email: String
//}

#Preview {
    ProfileView()
}
