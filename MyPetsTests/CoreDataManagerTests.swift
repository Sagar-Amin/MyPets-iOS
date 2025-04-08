//
//  CoreDataManagerTests.swift
//  MyPets
//
//  Created by Sagar Amin on 3/29/25.
//

import XCTest
import CoreData
@testable import MyPets

class CoreDataManagerTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        
        // Use an in-memory store for testing
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        coreDataManager.container.persistentStoreDescriptions = [persistentStoreDescription]
        
    }
    
    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }
    
    func testSingletonInstance() {
        let instance1 = CoreDataManager.shared
        let instance2 = CoreDataManager.shared
        XCTAssertTrue(instance1 === instance2, "CoreDataManager should be a singleton")
    }
    
    func testSaveContext() {
        let context = coreDataManager.viewContext
        
        let pet = FavoritePet(context: context)
        pet.name = "Test Pet"
        pet.image_url = "test_url"
        pet.type = "dog"
        pet.shedding = 1
        pet.playfulness = 2
        pet.grooming = 3
        
        XCTAssertNoThrow(try context.save(), "Should save context without errors")
    }
    
    func testFavoritePetToPetConversion() {
        let context = coreDataManager.viewContext
        let favoritePet = FavoritePet(context: context)
        
        favoritePet.name = "Fluffy"
        favoritePet.image_url = "http://example.com/fluffy.jpg"
        favoritePet.type = "cat"
        favoritePet.shedding = 2
        favoritePet.playfulness = 3
        favoritePet.grooming = 1
        
        let pet = favoritePet.toPet()
        
        XCTAssertNotNil(pet, "Conversion should succeed")
        XCTAssertEqual(pet?.name, "Fluffy")
        XCTAssertEqual(pet?.type, .cat)
    }
    
    func testFavoritePetFromPet() {
        let context = coreDataManager.viewContext
        let favoritePet = FavoritePet(context: context)
        let pet = Pet(name: "Max", image_link: "http://example.com/max.jpg", type: .dog, shedding: 3, playfulness: 4, grooming: 2)
        
        favoritePet.fromPet(pet)
        
        XCTAssertEqual(favoritePet.name, "Max")
        XCTAssertEqual(favoritePet.type, "dog")
        XCTAssertEqual(favoritePet.shedding, 3)
    }
}
