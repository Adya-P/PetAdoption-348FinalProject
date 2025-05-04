//
//  PetListViewModel.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/31/25.
//
import SQLite
import Foundation

class PetListViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var filteredPets: [Pet] = []
    @Published var isLoading = false

    @Published var selectedSpecies: String? = nil {
        didSet {
            if selectedSpecies != oldValue {
                selectedBreed = nil
                filterPets()
            }
        }
    }
    @Published var selectedBreed: String? = nil {
        didSet { filterPets() }
    }
    @Published var selectedAvailability: Int? = nil {  // 1 = Available, 0 = Not Available
        didSet { filterPets() }
    }
    
    @Published var minAgeDouble: Double = 0 {
        didSet { if autoApplyFilters { filterPets() } }
    }
    @Published var maxAgeDouble: Double = 20 {
        didSet { if autoApplyFilters { filterPets() } }
    }
    @Published var selectedShelterLocation: String? = nil {
        didSet { if autoApplyFilters { filterPets() } }
    }
    
    // Stats selection
    @Published var selectedStatsType: Int = 0
    
    // Config
    private var autoApplyFilters = false
    
    var petStats: (count: Int, avgAge: Double?) {
        let count = filteredPets.count
        let avgAge = count > 0 ? filteredPets.map { Double($0.age) }.reduce(0, +) / Double(count) : nil
        return (count, avgAge)
    }

    func fetchPets() {
//        let fetchedPets = DatabaseManager.shared.getAllPets()
//        DispatchQueue.main.async {
//            self.pets = fetchedPets
//            self.filterPets()  // Apply filters immediately after fetching
//        }
        isLoading = true
        let fetchedPets = DatabaseManager.shared.getAllPets()
        DispatchQueue.main.async {
            self.pets = fetchedPets
            self.filterPets()
            self.isLoading = false
        }
    }

    func filterPets() {
        DispatchQueue.main.async {
            self.filteredPets = self.pets.filter { pet in
//                let speciesMatch = self.selectedSpecies == nil || pet.species == self.selectedSpecies
//                let breedMatch = self.selectedBreed == nil || pet.breed == self.selectedBreed
//                let availabilityMatch = self.selectedAvailability == nil || pet.available == self.selectedAvailability
//                return speciesMatch && breedMatch && availabilityMatch
                
                let speciesMatch = self.selectedSpecies == nil || pet.species == self.selectedSpecies
                let breedMatch = self.selectedBreed == nil || pet.breed == self.selectedBreed
                let availabilityMatch = self.selectedAvailability == nil || pet.available == self.selectedAvailability
                            
                // Age range filter
                let minAge = Int(self.minAgeDouble)
                let maxAge = Int(self.maxAgeDouble)
                let ageMatch = pet.age >= minAge && pet.age <= maxAge
                
                return speciesMatch && breedMatch && availabilityMatch && ageMatch
            }
        }
    }
    
    // Uses idx_pets_name index
    func searchPetName(_ name: String) {
        if name.isEmpty {
            fetchPets()
            return
        }
        
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            // This would be a separate method in DatabaseManager that uses the idx_pets_name index
            let filteredPets = self.pets.filter { $0.name.lowercased().contains(name.lowercased()) }
            
            // In a real implementation, you'd call a database method like:
            // let filteredPets = DatabaseManager.shared.getPetsByName(name)
            
            DispatchQueue.main.async {
                self.filteredPets = filteredPets
                self.isLoading = false
            }
        }
    }
        
    // Uses idx_pets_species_breed compound index
    func filterPetsBySpeciesAndBreed() {
        guard let species = selectedSpecies else {
            // If no species selected, just apply regular filters
            filterPets()
            return
        }
        
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            // This would call the database method that uses the idx_pets_species_breed index
            let filteredPets = DatabaseManager.shared.getPetsBySpeciesAndBreed(species: species, breed: self.selectedBreed)
            
            DispatchQueue.main.async {
                self.filteredPets = filteredPets
                self.isLoading = false
            }
        }
    }
    
    // Uses idx_pets_age_available compound index
    func filterPetsByAgeRange(minAge: Int, maxAge: Int) {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            let availablePets = DatabaseManager.shared.getAvailablePetsByAgeRange(minAge: minAge, maxAge: maxAge)
            
            DispatchQueue.main.async {
                // If availability filter is specifically set to "Not Available", don't show these results
                if self.selectedAvailability == 0 {
                    self.filterPets() // Just use regular filtering
                } else {
                    self.filteredPets = availablePets
                }
            self.isLoading = false
            }
        }
    }
    
    // Uses idx_shelters_location index
    func filterPetsByShelterLocation(_ location: String) {
        if location.isEmpty {
            // Reset to regular filtering if no location specified
            filterPets()
            return
        }
        
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
        // First get shelter IDs matching location
            let shelters = DatabaseManager.shared.getSheltersByLocation(location: location)
            let shelterIds = shelters.map { $0.id }
            
            // Then filter pets by these shelter IDs
            var filteredPets: [Pet] = []
            for shelterId in shelterIds {
                // This uses the idx_pets_shelter_id index
                let pets = DatabaseManager.shared.getPetsByShelter(shelterId: Int(shelterId))
                filteredPets.append(contentsOf: pets)
            }
            
            DispatchQueue.main.async {
                self.filteredPets = filteredPets
                self.isLoading = false
            }
        }
    }
        
    func resetFilters() {
        selectedSpecies = nil
        selectedBreed = nil
        selectedAvailability = nil
        minAgeDouble = 0
        maxAgeDouble = 20
        selectedShelterLocation = nil
        fetchPets()
    }

    func uniqueSpecies() -> [String] {
        return Array(Set(pets.map { $0.species })).sorted()
    }
    
    func breedsBySelectedSpecies() -> [String?] {
        guard let species = selectedSpecies else {
            return []
        }
            
        let breeds = Set(pets.filter { $0.species == species }.map { $0.breed })
        return Array(breeds).sorted {
            ($0 ?? "") < ($1 ?? "")
        }
    }
    
    func addPet(name: String, sex: String, species: String, breed: String?, age: Int, shelterId: Int) -> Bool {
        guard !name.isEmpty, !sex.isEmpty, !species.isEmpty, age > 0 else {
            return false
        }
            
        DatabaseManager.shared.insertPet(
             name: name,
             sex: sex,
            species: species,
            breed: breed?.isEmpty == true ? nil : breed,
            age: age,
            imageUrl: nil,
            shelterId: shelterId
        )
        
        // Refresh the pet list
        fetchPets()
        return true
    }
    // Delete a pet from the database
    func deletePet(pet: Pet) {
        DatabaseManager.shared.deletePet(petId: pet.id)
        
        // Refresh the pet list
        fetchPets()
    }
    
// Get all shelters for the pet form
    func getAllShelters() -> [(id: Int64, name: String, location: String)] {
        guard let db = DatabaseManager.shared.db else {
            return []
        }
            
        var shelterList: [(id: Int64, name: String, location: String)] = []
        do {
            let shelters = Table("Shelters")
            for shelter in try db.prepare(shelters) {
                shelterList.append((
                    id: shelter[Expression<Int64>("id")],
                    name: shelter[Expression<String>("name")],
                    location: shelter[Expression<String>("location")]
                ))
            }
        } catch {
            print("Error fetching shelters: \(error)")
        }
            
        return shelterList
    }
        
        // Toggle pet availability (adopt/make available)
    func togglePetAvailability(pet: Pet) {
        let newAvailability = pet.available == 1 ? false : true
        DatabaseManager.shared.updatePetAvailability(petId: pet.id, isAvailable: newAvailability)
        fetchPets()
    }
}
