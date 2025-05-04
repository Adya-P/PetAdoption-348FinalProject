//
//  Models.swift
//  PetAdoption
//
//  Created by Adya Shreya Pattanaik on 3/30/25.
//

import Foundation

struct User {
    let id: Int64
    let name: String
    let email: String
}

struct Pet: Identifiable {
    let id: Int64
    let name: String
    let sex: String
    let species: String
    let breed: String?
    let age: Int
    let imageUrl: String?
    let available: Int
    var shelter: Int64 { id }
    var isAvailable: Bool {
        return available == 1
    }
}

struct Shelter: Identifiable {
    let id: Int
    let name: String
    let location: String
}

struct AdoptionRequest {
    let id: Int64
    let userId: Int64
    let petId: Int64
    let status: String
}

