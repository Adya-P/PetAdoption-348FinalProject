//
//  SheltersView.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/31/25.
//

import SwiftUI

struct SheltersView: View {
    @State private var shelters: [Shelter] = []

    var body: some View {
        NavigationView {
            List(shelters) { shelter in
                VStack(alignment: .leading) {
                    Text(shelter.name)
                        .font(.headline)
                    Text(shelter.location)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Shelters")
            .onAppear {
                fetchShelters()
            }
        }
    }
    
    private func fetchShelters() {
        // Replace with actual data fetch logic (e.g., from DatabaseManager)
        shelters = [
            Shelter(id: 1, name: "Happy Paws Shelter", location: "New York, NY"),
            Shelter(id: 2, name: "Furry Friends Rescue", location: "Los Angeles, CA"),
            Shelter(id: 3, name: "Animal Haven", location: "San Francisco, CA")
        ]
    }
}

// Sample Shelter Model


#Preview {
    SheltersView()
}
