//
//  FavoritesView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI
import CoreData

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = FavoritesViewModel(context: CoreDataManager.shared.container.viewContext)
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.favoritePets.isEmpty {
                    VStack {
                        Image(systemName: "heart.slash")
                            .font(.largeTitle)
                        Text("No favorites yet")
                            .font(.headline)
                    }
                    .foregroundColor(.secondary)
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: viewModel.loadFavorites)
                } else {
                    List {
                        ForEach(viewModel.favoritePets, id: \.name) { pet in
                            NavigationLink {
                                PetDetailView(pet: pet)
                                    .environment(\.managedObjectContext, context)
                            } label: {
                                PetRow(pet: pet)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(pet)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .refreshable {
                viewModel.loadFavorites()
            }
            .onAppear {
                viewModel.loadFavorites()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.container.viewContext
        
        // Add test favorite
        let testPet = Pet(name: "Fluffy", image_link: "https://api-ninjas.com/images/dogs/affenpinscher.jpg", type: .cat, shedding: 3, playfulness: 3, grooming: 5)
        let favorite = FavoritePet(context: context)
        favorite.fromPet(testPet)
        try? context.save()
        
        return FavoritesView()
            .environment(\.managedObjectContext, context)
    }
}
