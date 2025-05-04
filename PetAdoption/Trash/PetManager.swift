////
////  PetManager.swift
////  PetAdoption
////
////  Created by Adya Shreya Pattanaik on 3/31/25.
////
//
//import SQLite
//
//class PetManager {
//    static let shared = PetManager()
//    let db = DatabaseManager.shared.db
//
//    // Add a new pet
//    func addPet(name: String, age: Int, breed: String, species: String, available: Int, imageURL: String?, shelterID: Int) -> Int64? {
//        do {
//            guard let db = db else { return nil }
//
//            let insert = DatabaseManager.shared.pets.insert(
//                DatabaseManager.shared.petName <- name,
//                DatabaseManager.shared.petAge <- age,
//                DatabaseManager.shared.petBreed <- breed,
//                DatabaseManager.shared.petSpecies <- species,
//                DatabaseManager.shared.petAvailable <- available,
//                DatabaseManager.shared.petImageURL <- imageURL,
//                DatabaseManager.shared.shelterID <- shelterID
//            )
//
//            let petID = try db.run(insert)
//            return petID
//        } catch {
//            print("Error inserting pet: \(error)")
//            return nil
//        }
//    }
//
//    // Edit a pet
//    func editPet(petID: Int64, name: String, age: Int, breed: String, species: String, available: Int, imageURL: String?, shelterID: Int) {
//        do {
//            guard let db = db else { return }
//
//            let pet = DatabaseManager.shared.pets.filter(DatabaseManager.shared.petID == petID)
//            try db.run(pet.update(
//                DatabaseManager.shared.petName <- name,
//                DatabaseManager.shared.petAge <- age,
//                DatabaseManager.shared.petBreed <- breed,
//                DatabaseManager.shared.petSpecies <- species,
//                DatabaseManager.shared.petAvailable <- available,
//                DatabaseManager.shared.petImageURL <- imageURL,
//                DatabaseManager.shared.shelterID <- shelterID
//            ))
//        } catch {
//            print("Error updating pet: \(error)")
//        }
//    }
//
//    // Delete a pet
//    func deletePet(petID: Int64) {
//        do {
//            guard let db = db else { return }
//
//            let pet = DatabaseManager.shared.pets.filter(DatabaseManager.shared.petID == petID)
//            try db.run(pet.delete())
//        } catch {
//            print("Error deleting pet: \(error)")
//        }
//    }
//
//    func getAllPets() -> [Pet] {
//            guard let db = db else { return [] }
//
//            var petList = [Pet]()
//
//            do {
////                let pets = try db.prepare(DatabaseManager.shared.pets)
////                for pet in pets {
////                    petList.append(Pet(id: pet[petId], name: pet[name], sex: pet[sex], species: pet[species], breed: pet[breed], age: pet[age]))
////                }
//                for pet in try db.prepare(DatabaseManager.shared.pets) {
//                    petList.append(Pet(id: try pet.get(DatabaseManager.shared.petID),
//                                    name: try pet.get(DatabaseManager.shared.petName),
//                                    sex: try pet.get(DatabaseManager.shared.petSex),
//                                    species: try pet.get(DatabaseManager.shared.petSpecies),
//                                    breed: try pet.get(DatabaseManager.shared.petBreed),
//                                    age: try pet.get(DatabaseManager.shared.petAge),
//                                    imageUrl: try pet.get(DatabaseManager.shared.petImageURL),
//                                    available: try pet.get(DatabaseManager.shared.petAvailable)
//                    ))
//                }
//            } catch {
//                print("Error fetching pets: \(error)")
//            }
//
//            return petList
//        }
//}
