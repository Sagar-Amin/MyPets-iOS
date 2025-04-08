//
//  CoreDataManager.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyPets")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving Core Data context: \(error)")
            }
        }
    }
}


extension FavoritePet {
    func toPet() -> Pet? {
        guard let name = name,
              let image_url = image_url else {
            return nil
        }
        
        return Pet(name: name, image_link: image_url, type: Pet.PetType(rawValue: type!) ?? Pet.PetType.cat,
                   shedding: Int(shedding), playfulness: Int(playfulness), grooming: Int(grooming))
    }
    
    func fromPet(_ pet: Pet) {
        
        self.name = pet.name
        self.image_url = pet.image_link
        self.type = pet.type.rawValue
        self.shedding = Int16(pet.shedding)
        self.playfulness = Int16(pet.playfulness)
        self.grooming = Int16(pet.grooming)
        
    }
}
