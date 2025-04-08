//
//  FavoritesViewModel.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import CoreData
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoritePets: [Pet] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadFavorites()
    }
    
    func loadFavorites() {
        isLoading = true
        error = nil
        
        let request = FavoritePet.fetchRequest()
        
        do {
            let favorites = try context.fetch(request)
            favoritePets = favorites.compactMap { $0.toPet() }
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func removeFavorite(_ pet: Pet) {
        let request = FavoritePet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", pet.name)
        
        do {
            let results = try context.fetch(request)
            if let favoriteToRemove = results.first {
                context.delete(favoriteToRemove)
                try context.save()
                loadFavorites() // Refresh the list
            }
        } catch {
            self.error = error
        }
    }
}
