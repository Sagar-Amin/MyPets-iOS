//
//  Pet.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//
import SwiftUI

struct Pet: Codable, Equatable, Identifiable {
    // Add computed id property for Identifiable
    var id = UUID()
    
    let name: String
    let image_link: String
    var type: PetType
    let shedding: Int
    let playfulness: Int
    let grooming: Int
    
    enum PetType: String, Codable {
        case dog, cat
    }
    
    // Custom CodingKeys to match API response
    enum CodingKeys: String, CodingKey {
        case name
        case image_link
        case shedding
        case playfulness
        case grooming
        // We don't need to list keys we're ignoring
    }
    
    // Custom decoder to handle only the fields we want
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        image_link = try container.decode(String.self, forKey: .image_link)
        shedding = try container.decode(Int.self, forKey: .shedding)
        playfulness = try container.decode(Int.self, forKey: .playfulness)
        grooming = try container.decode(Int.self, forKey: .grooming)
        
        // Temporary type, will be set in APIService
        type = .dog
    }
    
    init(name: String, image_link: String, type: PetType, shedding: Int, playfulness: Int, grooming: Int) {
           self.name = name
           self.image_link = image_link
           self.type = type
           self.shedding = shedding
           self.playfulness = playfulness
           self.grooming = grooming
       }
}

