//
//  ViewModelTests.swift
//  MyPets
//
//  Created by Sagar Amin on 3/29/25.
//

import XCTest
import Combine
import CoreData
@testable import MyPets

class ViewModelTests: XCTestCase {
    var coreDataManager: CoreDataManager!
    var authViewModel: AuthenticationViewModel!
    var petsViewModel: PetsViewModel!
    var favoritesViewModel: FavoritesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        // Set up in-memory Core Data stack
        coreDataManager = CoreDataManager.shared
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        coreDataManager.container.persistentStoreDescriptions = [persistentStoreDescription]
        
        authViewModel = AuthenticationViewModel()
        petsViewModel = PetsViewModel(context: coreDataManager.viewContext)
        favoritesViewModel = FavoritesViewModel(context: coreDataManager.viewContext)
        cancellables = []
        
        clearAllFavorites()
    }
    
    private func clearAllFavorites() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoritePet.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try coreDataManager.viewContext.execute(deleteRequest)
                try coreDataManager.viewContext.save()
            } catch {
                XCTFail("Failed to clear favorites: \(error)")
            }
        }
    
    override func tearDown() {
        coreDataManager = nil
        authViewModel = nil
        petsViewModel = nil
        favoritesViewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testPetsViewModelLoadPets() {
        let expectation = XCTestExpectation(description: "Pets loaded")
        
        petsViewModel.$pets
            .dropFirst() // Ignore initial empty value
            .sink { pets in
                XCTAssertFalse(pets.isEmpty, "Should load some pets")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        petsViewModel.loadPets()
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testToggleFavorite() {
        let testPet = Pet(name: "TestPet", image_link: "test.jpg", type: .dog, shedding: 1, playfulness: 2, grooming: 3)
        
        // Initial state should not be favorite
        XCTAssertFalse(petsViewModel.isFavorite(testPet), "Pet should not be favorite initially")
        
        // Toggle favorite
        petsViewModel.toggleFavorite(testPet)
        XCTAssertTrue(petsViewModel.isFavorite(testPet), "Pet should be favorite after toggle")
        
        // Toggle again to remove
        petsViewModel.toggleFavorite(testPet)
        XCTAssertFalse(petsViewModel.isFavorite(testPet), "Pet should not be favorite after second toggle")
    }
    
    func testFavoritesViewModelLoadFavorites() {
        let testPet = Pet(name: "FavoritePet", image_link: "favorite.jpg", type: .cat, shedding: 2, playfulness: 3, grooming: 1)
        
        // Add a favorite
        let favorite = FavoritePet(context: coreDataManager.viewContext)
        favorite.fromPet(testPet)
        try? coreDataManager.viewContext.save()
        
        // Test loading
        favoritesViewModel.loadFavorites()
        
        XCTAssertEqual(favoritesViewModel.favoritePets.count, 1, "Should load 1 favorite")
        XCTAssertEqual(favoritesViewModel.favoritePets.first?.name, "FavoritePet", "Loaded favorite should match")
    }
    
    func testRemoveFavorite() {
        let testPet = Pet(name: "PetToRemove", image_link: "remove.jpg", type: .dog, shedding: 3, playfulness: 4, grooming: 2)
        
        // Add a favorite
        let favorite = FavoritePet(context: coreDataManager.viewContext)
        favorite.fromPet(testPet)
        try? coreDataManager.viewContext.save()
        
        // Verify it's added
        favoritesViewModel.loadFavorites()
        XCTAssertEqual(favoritesViewModel.favoritePets.count, 1, "Should have 1 favorite initially")
        
        // Remove it
        favoritesViewModel.removeFavorite(testPet)
        
        // Verify it's removed
        XCTAssertEqual(favoritesViewModel.favoritePets.count, 0, "Should have 0 favorites after removal")
    }
}
