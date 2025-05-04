//
//  DatabaseManager.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/31/25.
//

import SQLite
import Foundation

class DatabaseManager {
    typealias Expression = SQLite.Expression
    static let shared = DatabaseManager()
    var db: Connection?
    
    // Table definitions
    let pets = Table("Pets")
    let users = Table("Users")
    let shelters = Table("Shelters")
    let adoptionRequests = Table("AdoptionRequests")
    
    let petID = Expression<Int64>("id")
    let petName = Expression<String>("name")
    let petSex = Expression<String>("sex")
    let petSpecies = Expression<String>("species")
    let petBreed = Expression<String?>("breed")
    let petAge = Expression<Int>("age")
    let petImageURL = Expression<String?>("image_url")
    let shelterID = Expression<Int>("shelter_id")
    let petAvailable = Expression<Int>("available")
    
    let userID = Expression<Int64>("id")
    let userName = Expression<String>("name")
    let userEmail = Expression<String>("email")
    
    let adoptionID = Expression<Int64>("id")
    let adoptionPetID = Expression<Int64>("pet_id")
    let adoptionUserID = Expression<Int64>("user_id")
    let adoptionStatus = Expression<String>("status")
    
    private init() {
        do {
            //            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            //                let path = directory.appendingPathComponent("petAdoption.sqlite3").path
            //                try FileManager.default.removeItem(atPath: path)
            if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let path = directory.appendingPathComponent("petAdoption.sqlite3").path
                
                // FIX: Only try to remove the file if it exists
                if FileManager.default.fileExists(atPath: path) {
                    try FileManager.default.removeItem(atPath: path)
                }
                
                db = try Connection(path)
                
                try db?.execute("PRAGMA foreign_keys = ON")
                
                createTables()
                createIndexes()
                
                if try db?.scalar(pets.count) == 0 {
                    insertSampleData()
                }
                
            } else{
                db = nil
                print("failed to get document directory")
            }
        } catch {
            db = nil
            print("Database connection failed: \(error)")
        }
    }
    
    private func createTables() {
        do {
            //            try db?.run("DROP TABLE IF EXISTS Pets")
            
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userID, primaryKey: .autoincrement)
                t.column(userName)
                t.column(userEmail, unique: true)
            })
            
            try db?.run(pets.create(ifNotExists: true) { t in
                t.column(petID, primaryKey: .autoincrement)
                t.column(petName)
                t.column(petSex)
                t.column(petSpecies)
                t.column(petBreed)
                t.column(petAge)
                t.column(petImageURL)
                t.column(shelterID)
                t.column(petAvailable, defaultValue: 1)
            })
            
            try db?.run(shelters.create(ifNotExists: true) { t in
                t.column(Expression<Int64>("id"), primaryKey: .autoincrement)
                t.column(Expression<String>("name"))
                t.column(Expression<String>("location"))
            })
            
            try db?.run(adoptionRequests.create(ifNotExists: true) { t in
                t.column(Expression<Int64>("id"), primaryKey: .autoincrement)
                t.column(Expression<Int64>("user_id"))
                t.column(Expression<Int64>("pet_id"))
                t.column(Expression<String>("status"))
                
            })
            
            print("Tables created successfully!")
        } catch {
            print("Error creating tables: \(error)")
        }
        
    }
    
    private func createIndexes() {
        do {
            // Indexes for Pets table
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_species ON Pets(species)") // For species filtering
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_breed ON Pets(breed)") // For breed filtering
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_available ON Pets(available)") // For availability filtering
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_shelter_id ON Pets(shelter_id)") // For shelter filtering
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_age ON Pets(age)") // For age filtering/sorting
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_name ON Pets(name)") // For name searches
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_species_breed ON Pets(species, breed)") // For combined species/breed filtering
            try db?.run("CREATE INDEX IF NOT EXISTS idx_pets_age_available ON Pets(age, available)") // For finding available pets by age range
            
            // Indexes for Users table
            try db?.run("CREATE UNIQUE INDEX IF NOT EXISTS idx_users_email ON Users(email)") // For user email lookups
            try db?.run("CREATE INDEX IF NOT EXISTS idx_users_name ON Users(name)") // For name searches
                
            // Indexes for Shelters table
            try db?.run("CREATE INDEX IF NOT EXISTS idx_shelters_location ON Shelters(location)") // For location-based searches
            // Indexes for AdoptionRequests table
            try db?.run("CREATE INDEX IF NOT EXISTS idx_adoption_requests_user_id ON AdoptionRequests(user_id)") // For user's adoption requests
            try db?.run("CREATE INDEX IF NOT EXISTS idx_adoption_requests_pet_id ON AdoptionRequests(pet_id)") // For pet's adoption requests
            try db?.run("CREATE INDEX IF NOT EXISTS idx_adoption_requests_status ON AdoptionRequests(status)") // For filtering by status
            try db?.run("CREATE INDEX IF NOT EXISTS idx_adoption_requests_user_status ON AdoptionRequests(user_id, status)") // For user's requests with specific status
                    
            print("Indexes created successfully!")
        } catch {
            print("Error creating indexes: \(error)")
        }
    }
    
    private func insertSampleData() {
        do {
            insertUser(name: "Adya Pattanaik", email: "adyapattanaik@gmail.com")
            insertUser(name: "Mirabelle Chevalier", email: "mirachev@gmail.com")
            insertUser(name: "Morgan Esquire", email: "evangeline.equire@gmail.com")
            insertUser(name: "Sunny", email: "omori@gmail.com")
            insertUser(name: "Makoto Yuki", email: "tatsuya@gmail")
            
            insertShelter(name: "Almost Home", location: "West Lafayette, IN")
            insertShelter(name: "Harbor Animal Care Center", location: "San Pedro, CA")
            insertShelter(name: "Pets in Need", location: "Nashville, TN")
            
            insertPet(name: "Happy", sex: "Male", species: "Cat", breed: "Exceed", age: 10, imageUrl: nil, shelterId: 2)
            insertPet(name: "Mewo", sex:"Female", species: "Cat", breed: "Bombay Cat", age: 5, imageUrl: nil, shelterId: 1)
            insertPet(name: "Hedwig", sex: "Female", species: "Owl", breed: "Snowy Owl", age: 6, imageUrl: nil, shelterId: 1)
            insertPet(name: "Epona", sex: "Female", species: "Horse", breed: "Silver Bay Draft Horse/Clydesdale", age: 15, imageUrl: nil, shelterId: 1)
            insertPet(name: "Dogmeat", sex: "Male", species: "Dog", breed: "German Shepherd", age: 7, imageUrl: nil, shelterId: 3)
            insertPet(name: "Koromaru", sex: "Male", species: "Dog", breed: "Shiba Inu", age: 3, imageUrl: nil, shelterId: 2)
            insertPet(name: "Perry", sex: "Male", species: "Platypus", breed: nil, age: 5, imageUrl: nil, shelterId: 3)
            
            updatePetAvailability(petId: 2, isAvailable: false)
            updatePetAvailability(petId: 6, isAvailable: false)
            
            print("Sample data inserted successfully!")
        } catch {
            print("Error inserting sample data: \(error)")
        }
    }
    
    // Insert a new user
    func insertUser(name: String, email: String) {
        let users = Table("Users")
        let userName = Expression<String>("name")
        let userEmail = Expression<String>("email")
        
        // Check if email already exists in the database
        let query = users.filter(userEmail == email)
        
        do {
            // Check if any user with the same email exists
            let existingUser = try db?.pluck(query)
            if existingUser != nil {
                print("Error: User with email \(email) already exists.")
                return
            }
            
            // Insert new user if no duplicate email found
            let insert = users.insert(userName <- name, userEmail <- email)
            try db?.run(insert)
            print("User inserted successfully.")
        } catch {
            print("Error inserting user: \(error)")
        }
    }
    
    // Insert a new pet
    func insertPet(name: String, sex: String, species: String, breed: String?, age: Int, imageUrl: String?, shelterId: Int) {
        let pets = Table("Pets")
        let petName = Expression<String>("name")
        let petSex = Expression<String>("sex")
        let petSpecies = Expression<String>("species")
        let petBreed = Expression<String?>("breed")
        let petAge = Expression<Int>("age")
        let petImageUrl = Expression<String?>("image_url")
        let petShelterId = Expression<Int>("shelter_id")
        let petAvailable = Expression<Int>("available")
        
        do {
            let insert = pets.insert(petName <- name,petSex <- sex, petSpecies <- species, petBreed <- breed, petAge <- age, petImageUrl <- imageUrl, petShelterId <- shelterId, petAvailable <- 1)
            try db?.run(insert)
            print("Pet inserted successfully.")
        } catch {
            print("Insert pet failed: \(error)")
        }
    }
    
    // Insert a new shelter
    func insertShelter(name: String, location: String) {
        let shelters = Table("Shelters")
        let shelterName = Expression<String>("name")
        let shelterLocation = Expression<String>("location")
        
        do {
            let insert = shelters.insert(shelterName <- name, shelterLocation <- location)
            try db?.run(insert)
            print("Shelter inserted successfully.")
        } catch {
            print("Insert shelter failed: \(error)")
        }
    }
    
    // Insert a new adoption request
    func insertAdoptionRequest(userId: Int, petId: Int, status: String) {
        let adoptionRequests = Table("AdoptionRequests")
        let requestUserId = Expression<Int>("user_id")
        let requestPetId = Expression<Int>("pet_id")
        let requestStatus = Expression<String>("status")
        
        do {
            let insert = adoptionRequests.insert(requestUserId <- userId, requestPetId <- petId, requestStatus <- status)
            try db?.run(insert)
            print("Adoption request inserted successfully.")
        } catch {
            print("Insert adoption request failed: \(error)")
        }
    }
    
    func updatePetAvailability(petId: Int64, isAvailable: Bool) {
        let pets = Table("Pets")
        let petIdColumn = Expression<Int64>("id")
        let petAvailable = Expression<Int>("available")
        
        do {
            let pet = pets.filter(petIdColumn == petId)
            try db?.run(pet.update(petAvailable <- (isAvailable ? 1 : 0)))
            print("Pet availability updated.")
        } catch {
            print("Update pet availability failed: \(error)")
        }
    }
    
    func deletePet(petId: Int64) {
        let pets = Table("Pets")
        let petIdColumn = Expression<Int64>("id")
        
        do {
            let pet = pets.filter(petIdColumn == petId)
            try db?.run(pet.delete())
            print("Pet deleted successfully.")
        } catch {
            print("Delete pet failed: \(error)")
        }
    }
    
    func getAllPets() -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        do {
            let count = try db.scalar(pets.count)
            if count == 0 {
                print("No pets found in the database.")
                return petList
            }
            for pet in try db.prepare(pets) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("loaded pets")
        } catch {
            print("Error fetching pets: \(error)")
        }
        return petList
    }
    
    func verifyTableColumns() {
        guard let db = db else { return }
        
        do {
            let schema = try db.prepare("PRAGMA table_info(Pets);")
            for row in schema {
                print(row)  // Print column names and types to verify
            }
        } catch {
            print("Error fetching table schema: \(error)")
        }
    }
    
    
    
    func getPetsBySpecies(species: String) -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            let query = pets.filter(petSpecies == species)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) pets of species: \(species)")
        } catch {
            print("Error fetching pets by species: \(error)")
        }
        return petList
    }
    
    // Get available pets (benefits from idx_pets_available)
    func getAvailablePets() -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            let query = pets.filter(petAvailable == 1)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) available pets")
        } catch {
            print("Error fetching available pets: \(error)")
        }
        return petList
    }
    
    // Get pets by shelter (benefits from idx_pets_shelter_id)
    func getPetsByShelter(shelterId: Int) -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            let query = pets.filter(shelterID == shelterId)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) pets from shelter ID: \(shelterId)")
        } catch {
            print("Error fetching pets by shelter: \(error)")
        }
        return petList
    }
    
    // Get pets by age range (benefits from idx_pets_age)
    func getPetsByAgeRange(minAge: Int, maxAge: Int) -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            let query = pets.filter(petAge >= minAge && petAge <= maxAge)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) pets between ages \(minAge) and \(maxAge)")
        } catch {
            print("Error fetching pets by age range: \(error)")
        }
        return petList
    }
    
    // Get user's adoption requests (benefits from idx_adoption_requests_user_id)
    func getAdoptionRequestsByUser(userId: Int64) -> [AdoptionRequest] {
        var requestList: [AdoptionRequest] = []
        guard let db = db else {
            print("Database connection is nil.")
            return requestList
        }
        
        do {
            let query = adoptionRequests.filter(adoptionUserID == userId)
            for request in try db.prepare(query) {
                requestList.append(AdoptionRequest(
                    id: request[adoptionID],
                    userId: request[adoptionUserID],
                    petId: request[adoptionPetID],
                    status: request[adoptionStatus]
                ))
            }
            print("Found \(requestList.count) adoption requests for user ID: \(userId)")
        } catch {
            print("Error fetching adoption requests by user: \(error)")
        }
        return requestList
    }
    
    // Get user by email (benefits from idx_users_email)
    func getUserByEmail(email: String) -> User? {
        guard let db = db else {
            print("Database connection is nil.")
            return nil
        }
        
        do {
            let query = users.filter(userEmail == email)
            if let user = try db.pluck(query) {
                return User(
                    id: user[userID],
                    name: user[userName],
                    email: user[userEmail]
                )
            }
        } catch {
            print("Error fetching user by email: \(error)")
        }
        return nil
    }
    
    
    // Gets pet statistics grouped by species (benefits from idx_pets_species)
    func getPetStatsBySpecies() -> [(species: String, count: Int, avgAge: Double)] {
        var stats: [(species: String, count: Int, avgAge: Double)] = []
        guard let db = db else {
            print("Database connection is nil.")
            return stats
        }
        
        do {
            let query = "SELECT species, COUNT(*) as count, AVG(age) as avg_age FROM Pets GROUP BY species"
            let results = try db.prepare(query)
            
            for row in results {
                let species = row[0] as? String ?? "Unknown"
                let count = row[1] as? Int ?? 0
                let avgAge = row[2] as? Double ?? 0.0
                stats.append((species: species, count: count, avgAge: avgAge))
            }
        } catch {
            print("Error getting pet statistics: \(error)")
        }
        
        return stats
    }
    
    // Gets adoption statistics by status (benefits from idx_adoption_requests_status)
    func getAdoptionStatsByStatus() -> [(status: String, count: Int)] {
        var stats: [(status: String, count: Int)] = []
        guard let db = db else {
            print("Database connection is nil.")
            return stats
        }
        
        do {
            let query = "SELECT status, COUNT(*) as count FROM AdoptionRequests GROUP BY status"
            let results = try db.prepare(query)
            
            for row in results {
                let status = row[0] as? String ?? "Unknown"
                let count = row[1] as? Int ?? 0
                stats.append((status: status, count: count))
            }
        } catch {
            print("Error getting adoption statistics: \(error)")
        }
        
        return stats
    }
    
    func getPetsBySpeciesAndBreed(species: String, breed: String?) -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            // This query benefits from the compound index idx_pets_species_breed
            let query = pets.filter(petSpecies == species && petBreed == breed)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) \(breed ?? "unknown") \(species)")
        } catch {
            print("Error fetching pets by species and breed: \(error)")
        }
        return petList
    }

    // Get available pets by age range (uses idx_pets_age_available)
    func getAvailablePetsByAgeRange(minAge: Int, maxAge: Int) -> [Pet] {
        var petList: [Pet] = []
        guard let db = db else {
            print("Database connection is nil.")
            return petList
        }
        
        do {
            // This query benefits from the compound index idx_pets_age_available
            let query = pets.filter(petAvailable == 1 && petAge >= minAge && petAge <= maxAge)
            for pet in try db.prepare(query) {
                petList.append(Pet(id: pet[petID],
                                   name: pet[petName],
                                   sex: pet[petSex],
                                   species: pet[petSpecies],
                                   breed: pet[petBreed],
                                   age: pet[petAge],
                                   imageUrl: pet[petImageURL],
                                   available: pet[petAvailable]
                                  ))
            }
            print("Found \(petList.count) available pets between ages \(minAge) and \(maxAge)")
        } catch {
            print("Error fetching available pets by age range: \(error)")
        }
        return petList
    }

    // Get shelters by location (uses idx_shelters_location)
    func getSheltersByLocation(location: String) -> [(id: Int64, name: String, location: String)] {
        var shelterList: [(id: Int64, name: String, location: String)] = []
        guard let db = db else {
            print("Database connection is nil.")
            return shelterList
        }
        
        do {
            // This query benefits from the idx_shelters_location index
            let query = shelters.filter(Expression<String>("location").like("%\(location)%"))
            for shelter in try db.prepare(query) {
                shelterList.append((
                    id: shelter[Expression<Int64>("id")],
                    name: shelter[Expression<String>("name")],
                    location: shelter[Expression<String>("location")]
                ))
            }
            print("Found \(shelterList.count) shelters in location containing '\(location)'")
        } catch {
            print("Error fetching shelters by location: \(error)")
        }
        return shelterList
    }

    // Get users by name (uses idx_users_name)
    func getUsersByName(name: String) -> [User] {
        var userList: [User] = []
        guard let db = db else {
            print("Database connection is nil.")
            return userList
        }
        
        do {
            // This query benefits from the idx_users_name index
            let query = users.filter(userName.like("%\(name)%"))
            for user in try db.prepare(query) {
                userList.append(User(
                    id: user[userID],
                    name: user[userName],
                    email: user[userEmail]
                ))
            }
            print("Found \(userList.count) users with names containing '\(name)'")
        } catch {
            print("Error fetching users by name: \(error)")
        }
        return userList
    }

    // Get user's adoption requests by status (uses idx_adoption_requests_user_status)
    func getUserAdoptionRequestsByStatus(userId: Int64, status: String) -> [AdoptionRequest] {
        var requestList: [AdoptionRequest] = []
        guard let db = db else {
            print("Database connection is nil.")
            return requestList
        }
        
        do {
            // This query benefits from the compound index idx_adoption_requests_user_status
            let query = adoptionRequests.filter(adoptionUserID == userId && adoptionStatus == status)
            for request in try db.prepare(query) {
                requestList.append(AdoptionRequest(
                    id: request[adoptionID],
                    userId: request[adoptionUserID],
                    petId: request[adoptionPetID],
                    status: request[adoptionStatus]
                ))
            }
            print("Found \(requestList.count) '\(status)' adoption requests for user ID: \(userId)")
        } catch {
            print("Error fetching user's adoption requests by status: \(error)")
        }
        return requestList
    }

    // Get comprehensive pet report with shelter info (uses multiple indexes)
    func getComprehensivePetReport() -> [(petName: String, species: String, age: Int, shelterName: String, location: String, available: Bool)] {
        var report: [(petName: String, species: String, age: Int, shelterName: String, location: String, available: Bool)] = []
        guard let db = db else {
            print("Database connection is nil.")
            return report
        }
        
        do {
            // This query uses joins that benefit from idx_pets_shelter_id
            let query = """
                SELECT p.name, p.species, p.age, s.name, s.location, p.available 
                FROM Pets p
                JOIN Shelters s ON p.shelter_id = s.id
                ORDER BY p.species, p.age
            """
            
            let results = try db.prepare(query)
            for row in results {
                let name = row[0] as? String ?? "Unknown"
                let species = row[1] as? String ?? "Unknown"
                let age = row[2] as? Int ?? 0
                let shelterName = row[3] as? String ?? "Unknown"
                let location = row[4] as? String ?? "Unknown"
                let available = (row[5] as? Int ?? 0) == 1
                
                report.append((
                    petName: name,
                    species: species,
                    age: age,
                    shelterName: shelterName,
                    location: location,
                    available: available
                ))
            }
            print("Generated comprehensive pet report with \(report.count) entries")
        } catch {
            print("Error generating comprehensive pet report: \(error)")
        }
        
        return report
    }

    // Get adoption statistics by shelter (uses multiple indexes)
    func getAdoptionStatsByShelter() -> [(shelterName: String, totalPets: Int, adopted: Int, available: Int)] {
        var stats: [(shelterName: String, totalPets: Int, adopted: Int, available: Int)] = []
        guard let db = db else {
            print("Database connection is nil.")
            return stats
        }
        
        do {
            // This query uses joins that benefit from idx_pets_shelter_id and idx_pets_available
            let query = """
                SELECT s.name, 
                       COUNT(p.id) as total_pets,
                       SUM(CASE WHEN p.available = 0 THEN 1 ELSE 0 END) as adopted,
                       SUM(CASE WHEN p.available = 1 THEN 1 ELSE 0 END) as available
                FROM Shelters s
                LEFT JOIN Pets p ON s.id = p.shelter_id
                GROUP BY s.id
            """
            
            let results = try db.prepare(query)
            for row in results {
                let shelterName = row[0] as? String ?? "Unknown"
                let totalPets = row[1] as? Int ?? 0
                let adopted = row[2] as? Int ?? 0
                let available = row[3] as? Int ?? 0
                
                stats.append((
                    shelterName: shelterName,
                    totalPets: totalPets,
                    adopted: adopted,
                    available: available
                ))
            }
            print("Generated adoption statistics by shelter with \(stats.count) entries")
        } catch {
            print("Error generating adoption statistics by shelter: \(error)")
        }
        
        return stats
    }
}
