//
//  ContentView.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PetListViewModel()
    @State private var showingAdvancedFilters = false
    @State private var searchText = ""
    @State private var selectedShelterLocation = ""
    @State private var showStats = false
    @State private var showingAddPetView = false
    
    // Stats state
    @State private var shelterStats: [(shelterName: String, totalPets: Int, adopted: Int, available: Int)] = []
    @State private var petStatsBySpecies: [(species: String, count: Int, avgAge: Double)] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Pet Adoption")
                    .font(.largeTitle)
                    .padding(.top)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search pet name...", text: $searchText)
                        .onChange(of: searchText) { _ in
                            viewModel.searchPetName(searchText)
                        }
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            viewModel.fetchPets()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Basic filters
                HStack {
                    // Species Filter
                    Picker("Species", selection: $viewModel.selectedSpecies) {
                        Text("All").tag(nil as String?)
                        ForEach(viewModel.uniqueSpecies(), id: \.self) { species in
                            Text(species).tag(species as String?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer()
                    
                    // Breed Filter (only shown when species is selected)
                    if viewModel.selectedSpecies != nil {
                        Picker("Breed", selection: $viewModel.selectedBreed) {
                            Text("All").tag(nil as String?)
                            ForEach(viewModel.breedsBySelectedSpecies(), id: \.self) { breed in
                                Text(breed ?? "Unknown").tag(breed as String?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    
                    Spacer()
                    
                    // Availability Filter
                    Picker("", selection: $viewModel.selectedAvailability) {
                        Text("All").tag(nil as Int?)
                        Text("Available").tag(1)
                        Text("Adopted").tag(0)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding(.horizontal)
                
                // Advanced filter button and age range
                HStack {
                    Button(action: {
                        showingAdvancedFilters.toggle()
                    }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                            Text(showingAdvancedFilters ? "Hide Filters" : "Advanced Filters")
                        }
                        .padding(8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showStats.toggle()
                        if showStats {
                            loadStats()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chart.bar")
                            Text(showStats ? "Hide Stats" : "Show Stats")
                        }
                        .padding(8)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                // Advanced filters panel
                if showingAdvancedFilters {
                    VStack(spacing: 12) {
                        // Age range
                        HStack {
                            Text("Age:")
                            Slider(value: $viewModel.minAgeDouble, in: 0...20, step: 1)
                            Text("\(Int(viewModel.minAgeDouble))")
                            
                            Text("to")
                            
                            Slider(value: $viewModel.maxAgeDouble, in: 0...20, step: 1)
                            Text("\(Int(viewModel.maxAgeDouble))")
                        }
                        
                        // Shelter location filter
                        HStack {
                            Text("Shelter Location:")
                            TextField("Enter location", text: $selectedShelterLocation)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            Button("Find") {
                                viewModel.filterPetsByShelterLocation(selectedShelterLocation)
                            }
                            .buttonStyle(.bordered)
                        }
                        
                        // Apply filters button
                        Button("Apply Age Filter") {
                            viewModel.filterPetsByAgeRange(
                                minAge: Int(viewModel.minAgeDouble),
                                maxAge: Int(viewModel.maxAgeDouble)
                            )
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Reset All Filters") {
                            viewModel.resetFilters()
                            searchText = ""
                            selectedShelterLocation = ""
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Statistics panel
                if showStats {
                    VStack {
                        HStack {
                            Text("Pet Statistics")
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Statistics tabs
                        Picker("Stats Type", selection: $viewModel.selectedStatsType) {
                            Text("By Species").tag(0)
                            Text("By Shelter").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        ScrollView {
                            if viewModel.selectedStatsType == 0 {
                                // Species stats
                                ForEach(petStatsBySpecies, id: \.species) { stat in
                                    VStack(alignment: .leading) {
                                        Text("\(stat.species)")
                                            .font(.headline)
                                        Text("Count: \(stat.count)")
                                        Text("Average Age: \(String(format: "%.1f", stat.avgAge)) years")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                            } else {
                                // Shelter stats
                                ForEach(shelterStats, id: \.shelterName) { stat in
                                    VStack(alignment: .leading) {
                                        Text("\(stat.shelterName)")
                                            .font(.headline)
                                        Text("Total Pets: \(stat.totalPets)")
                                        Text("Adopted: \(stat.adopted)")
                                        Text("Available: \(stat.available)")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .frame(height: 150)
                    }
                }
                
                // Pet count
                Text("\(viewModel.filteredPets.count) pets found")
                    .foregroundColor(.gray)
                    .padding(.top)
                
                // Pet List
                if viewModel.filteredPets.isEmpty {
                    Text("No pets available matching your criteria")
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.filteredPets) { pet in
                            NavigationLink(destination: PetDetailView(pet: pet, viewModel: viewModel)) {
                                PetRow(pet: pet)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarItems(trailing:
                Button(action: {
                    showingAddPetView = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.blue)
                }
            )
            .sheet(isPresented: $showingAddPetView) {
                AddPetView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchPets()
            }
        }
    }
    
    private func loadStats() {
        // Load statistics when stats panel is opened
        petStatsBySpecies = DatabaseManager.shared.getPetStatsBySpecies()
        shelterStats = DatabaseManager.shared.getAdoptionStatsByShelter()
    }
}

struct PetRow: View {
    let pet: Pet
    
    var body: some View {
        HStack {
            Image(systemName: pet.species == "Cat" ? "cat" :
                  pet.species == "Dog" ? "dog" : "pawprint")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(pet.name)
                    .font(.headline)
                Text("\(pet.species) • \(pet.breed ?? "Unknown breed") • \(pet.age) years")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Availability badge
            Text(pet.available == 1 ? "Available" : "Adopted")
                .font(.caption)
                .padding(5)
                .background(pet.available == 1 ? Color.green : Color.orange)
                .foregroundColor(.white)
                .cornerRadius(5)
        }
        .padding(.vertical, 4)
    }
}


struct PetDetailView: View {
    let pet: Pet
    let viewModel: PetListViewModel
    @State private var shelterName: String = "Loading..."
    @State private var shelterLocation: String = "Loading..."
    @State private var showingDeleteAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Pet image placeholder
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(1.5, contentMode: .fit)
                    
                    Image(systemName: pet.species == "Cat" ? "cat.fill" :
                          pet.species == "Dog" ? "dog.fill" : "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                }
                
                // Pet details
                Group {
                    Text(pet.name)
                        .font(.title)
                        .bold()
                    
                    // Basic info
                    InfoRow(label: "Species", value: pet.species)
                    InfoRow(label: "Breed", value: pet.breed ?? "Unknown")
                    InfoRow(label: "Sex", value: pet.sex)
                    InfoRow(label: "Age", value: "\(pet.age) years")
                    
                    // Status
                    HStack {
                        Text("Status:")
                            .fontWeight(.medium)
                        
                        Text(pet.available == 1 ? "Available for Adoption" : "Already Adopted")
                            .padding(5)
                            .background(pet.available == 1 ? Color.green : Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                    
                    Divider()
                    
                    // Shelter info
                    Text("Shelter Information")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    InfoRow(label: "Name", value: shelterName)
                    InfoRow(label: "Location", value: shelterLocation)
                }
                .padding(.horizontal)
                
                // Action buttons
                VStack {
                    // If pet is available, show "Mark as Adopted" button, otherwise show "Make Available" button
                    if pet.available == 1 {
                        Button(action: {
                            viewModel.togglePetAvailability(pet: pet)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Mark as Adopted")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            // Adoption request would go here
                        }) {
                            Text("Request Adoption")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    } else {
                        Button(action: {
                            viewModel.togglePetAvailability(pet: pet)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Make Available")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Delete button
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text("Delete Pet")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Delete Pet"),
                message: Text("Are you sure you want to delete \(pet.name)? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deletePet(pet: pet)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            loadShelterInfo()
        }
    }
    
    private func loadShelterInfo() {
        // This would use the shelter_id index to quickly load shelter information
        Task {
            // Simulating a database fetch
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                shelterName = "Pet Haven"
                shelterLocation = "123 Adoption Avenue, Petville"
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            Text(value)
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
