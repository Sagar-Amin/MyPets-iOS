//
//  HomeView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel = PetsViewModel(context: CoreDataManager.shared.container.viewContext)
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ErrorView(error: error, retryAction: viewModel.loadPets)
                } else {
                    List(viewModel.pets, id: \.name) { pet in
                        NavigationLink {
                            PetDetailView(pet: pet)
                                .environment(\.managedObjectContext, context)
                        } label: {
                            PetRow(pet: pet)
                        }
                    }
                }
            }
            .navigationTitle("My Pets")
            .refreshable {
                viewModel.loadPets()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = CoreDataManager.shared.container.viewContext
        let viewModel = PetsViewModel(context: context)
        
        // Add some test data
        let testPet1 = Pet(
                    name: "Fluffy",
                    image_link: "https://api-ninjas.com/images/dogs/affenpinscher.jpg",
                    type: .cat,
                    shedding: 3,
                    playfulness: 3,
                    grooming: 5
                )
                
                let testPet2 = Pet(
                    name: "Fluffy",
                    image_link: "https://api-ninjas.com/images/dogs/golden-retriever.jpg",
                    type: .dog,
                    shedding: 4,
                    playfulness: 5,
                    grooming: 2
                )
        viewModel.pets = [testPet1, testPet2]
        
        return HomeView()
            .environment(\.managedObjectContext, context)
            .environmentObject(viewModel)
    }
}
