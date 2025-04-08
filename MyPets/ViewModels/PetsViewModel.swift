//
//  PetsViewModel.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import Combine
import CoreData

class PetsViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadPets()
    }
    
    func loadPets() {
        isLoading = true
        error = nil
        
        let dogsPublisher = apiService.fetchDogs()
        
        let catsPublisher = apiService.fetchCats()
        
        Publishers.Zip(dogsPublisher, catsPublisher)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { (dogs, cats) in
                var allPets = dogs + cats
                allPets.sort { $0.name < $1.name }
                self.pets = allPets
            }
            .store(in: &cancellables)
    }
    
    func isFavorite(_ pet: Pet) -> Bool {
        let request = FavoritePet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", pet.name)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    
    func toggleFavorite(_ pet: Pet) { // favorite  & unfavorite
        let request = FavoritePet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", pet.name)
        
        do {
            let results = try context.fetch(request)
            
            if let existingFavorite = results.first {
                context.delete(existingFavorite)
            } else {
                let newFavorite = FavoritePet(context: context)
                newFavorite.fromPet(pet)
            }
            
            try context.save()
            objectWillChange.send()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}
