////
////  PetDetailView.swift
////  PetAdoption
////
////  Created by Adya Shreya Pattanaik on 3/31/25.
////
//
//import SwiftUI
//
//struct PetDetailView: View {
////    let pet: Pet  // This should match the model you use for pets
////
////    var body: some View {
////        VStack(spacing: 20) {
////            Text(pet.name)
////                .font(.largeTitle)
////                .bold()
////
////            Text("Species: \(pet.species)")
////                .font(.title2)
////
////            if let breed = pet.breed {
////                Text("Breed: \(breed)")
////            }
////
////            Text("Age: \(pet.age) years")
////                .font(.headline)
////
//////            if let description = pet.description {
//////                Text(description)
//////                    .font(.body)
//////                    .padding()
//////            }
////
////            Spacer()
////        }
////        .padding()
////        .navigationTitle(pet.name)
////    }
//    let pet: Pet
//    let viewModel: PetListViewModel
//    @State private var shelterName: String = "Loading..."
//    @State private var shelterLocation: String = "Loading..."
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // Pet image placeholder
//                ZStack {
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.3))
//                        .aspectRatio(1.5, contentMode: .fit)
//                    
//                    Image(systemName: pet.species == "Cat" ? "cat.fill" :
//                          pet.species == "Dog" ? "dog.fill" : "pawprint.fill")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.white)
//                }
//                
//                // Pet details
//                Group {
//                    Text(pet.name)
//                        .font(.title)
//                        .bold()
//                    
//                    // Basic info
//                    InfoRow(label: "Species", value: pet.species)
//                    InfoRow(label: "Breed", value: pet.breed ?? "Unknown")
//                    InfoRow(label: "Sex", value: pet.sex)
//                    InfoRow(label: "Age", value: "\(pet.age) years")
//                    
//                    // Status
//                    HStack {
//                        Text("Status:")
//                            .fontWeight(.medium)
//                        
//                        Text(pet.available == 1 ? "Available for Adoption" : "Already Adopted")
//                            .padding(5)
//                            .background(pet.available == 1 ? Color.green : Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(5)
//                    }
//                    
//                    Divider()
//                    
//                    // Shelter info
//                    Text("Shelter Information")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    InfoRow(label: "Name", value: shelterName)
//                    InfoRow(label: "Location", value: shelterLocation)
//                }
//                .padding(.horizontal)
//                
//                // Adoption button
//                if pet.available == 1 {
//                    Button(action: {
//                        // Adoption request would go here
//                    }) {
//                        Text("Request Adoption")
//                            .fontWeight(.bold)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }
//            }
//        }
//        .onAppear {
//            loadShelterInfo()
//        }
//    }
//    
//    private func loadShelterInfo() {
//        // This would use the shelter_id index to quickly load shelter information
//        Task {
//            // Simulating a database fetch
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                shelterName = "Pet Haven"
//                shelterLocation = "123 Adoption Avenue, Petville"
//            }
//        }
//    }
//}
