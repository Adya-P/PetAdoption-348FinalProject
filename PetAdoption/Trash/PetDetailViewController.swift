////
////  PetDetailViewController.swift
////  PetAdoption
////
////  Created by Adya Shreya Pattanaik on 3/30/25.
////
//
//
//import SwiftUI
//
//struct PetDetailViewController: View {
//    let pet: Pet
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text(pet.name)
//                .font(.largeTitle)
//                .bold()
//            
//            Text("Species: \(pet.species)")
//                .font(.title2)
//            Text("Breed: \(pet.breed ?? "")")
//                .font(.title2)
//            Text("Age: \(pet.age) years")
//                .font(.title2)
//            
//            Text("Status: \(pet.available == 1 ? "Available" : "Not Available")")
//                .font(.title2)
//                .foregroundColor(pet.available == 1 ? .green : .red)
//            
//            Button(action: adoptPet) {
//                Text("Adopt \(pet.name)")
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding(.top, 20)
//            
//            Spacer()
//        }
//        .padding()
//        .navigationTitle(pet.name)
//    }
//    
//    func adoptPet() {
//        print("Adoption request sent for \(pet.name)")
//    }
//}
