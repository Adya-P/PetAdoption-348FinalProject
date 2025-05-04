////
////  PetReportManager.swift
////  PetAdoption
////
////  Created by Adya Shreya Pattanaik on 3/31/25.
////
//
//import SQLite
//
//class PetReportManager {
//    static let shared = PetReportManager()
//    let db = DatabaseManager.shared.db
//
//    private init() {}
//    
//    // Fetch pets based on filters using prepared statements
////    func fetchFilteredPets(species: String?, available: Int?, minAge: Int?, maxAge: Int?) -> [(id: Int64, name: String, age: Int, species: String, available: Int)] {
////        guard let db = db else { return [] }
////
////        do {
////            var query = DatabaseManager.shared.pets.select(
////                DatabaseManager.shared.petID,
////                DatabaseManager.shared.petName,
////                DatabaseManager.shared.petAge,
////                DatabaseManager.shared.petSpecies,
////                DatabaseManager.shared.petAvailable
////            )
////
////            // Apply filters
////            if let species = species {
////                query = query.filter(DatabaseManager.shared.petSpecies == species)
////            }
////            if let available = available {
////                query = query.filter(DatabaseManager.shared.petAvailable == available)
////            }
////            if let minAge = minAge {
////                query = query.filter(DatabaseManager.shared.petAge >= minAge)
////            }
////            if let maxAge = maxAge {
////                query = query.filter(DatabaseManager.shared.petAge <= maxAge)
////            }
////
////            return try db.prepare(query).map { row in
////                let id = row[DatabaseManager.shared.petID]
////                let name = row[DatabaseManager.shared.petName]
////                let age = row[DatabaseManager.shared.petAge]
////                let species = row[DatabaseManager.shared.petSpecies]
////                let available = row[DatabaseManager.shared.petAvailable]
////                return (id, name, age, species, available)
////            }
////        } catch {
////            print("Error fetching pets: \(error)")
////            return []
////        }
////    }
////    
////    func fetchFilteredPets(pets: [Pet], species: String? = nil, breed: String? = nil, available: Int? = nil) -> [Pet] {
////            return pets.filter { pet in
////                (species == nil || pet.species == species) &&
////                (breed == nil || pet.breed == breed) &&
////                (available == nil || pet.available == available)
////            }
////        }
//
//    // Get pet statistics
////    func getPetStatistics() -> (Double?) {
////        guard let db = db else { return (nil) }
////
////        do {
////            let avgAge = try db.scalar(DatabaseManager.shared.pets.select(DatabaseManager.shared.petAge.average))
////            return (avgAge)
////        } catch {
////            print("Error calculating statistics: \(error)")
////            return (nil)
////        }
////    }
////    
////    func getPetStatistics(filteredPets: [Pet]) -> (averageAge: Double?, totalCount: Int) {
////        let totalCount = filteredPets.count
////        guard totalCount > 0 else { return (nil, 0) }
////
////        let totalAge = filteredPets.reduce(0.0) { $0 + Double($1.age) }
////        let avgAge = totalAge / Double(totalCount)
////
////        return (avgAge, totalCount)
////    }
//}
