//
//  AddPetView.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 5/2/25.
//

import SwiftUI

struct AddPetView: View {
    @ObservedObject var viewModel: PetListViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var sex: String = "Male"
    @State private var species: String = ""
    @State private var breed: String = ""
    @State private var age: String = ""
    @State private var selectedShelterId: Int64 = 1
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private var shelters: [(id: Int64, name: String, location: String)] {
        viewModel.getAllShelters()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pet Information")) {
                    TextField("Name", text: $name)
                    
                    Picker("Sex", selection: $sex) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Species", text: $species)
                        .autocapitalization(.words)
                    
                    TextField("Breed (Optional)", text: $breed)
                        .autocapitalization(.words)
                    
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Shelter Information")) {
                    Picker("Shelter", selection: $selectedShelterId) {
                        ForEach(shelters, id: \.id) { shelter in
                            Text("\(shelter.name) - \(shelter.location)").tag(shelter.id)
                        }
                    }
                }
                
                Button("Add Pet") {
                    addPet()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.blue)
            }
            .navigationTitle("Add New Pet")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Add Pet"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("successfully") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func addPet() {
        guard let ageInt = Int(age) else {
            alertMessage = "Please enter a valid age."
            showAlert = true
            return
        }
        
        let success = viewModel.addPet(
            name: name,
            sex: sex,
            species: species,
            breed: breed.isEmpty ? nil : breed,
            age: ageInt,
            shelterId: Int(selectedShelterId)
        )
        
        if success {
            alertMessage = "Pet added successfully!"
        } else {
            alertMessage = "Please fill in all required fields."
        }
        showAlert = true
    }
}
