//
//  PetDetailView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    @Environment(\.managedObjectContext) private var context
    @State private var showFullImage = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Pet Image
                AsyncImage(url: URL(string: pet.image_link)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                showFullImage = true
                            }
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Pet Name
                Text(pet.name)
                    .font(.title.bold())
                
                // Rating Details
                VStack(spacing: 16) {
                    ratingView(title: "Shedding", value: pet.shedding, icon: "scissors")
                    ratingView(title: "Playfulness", value: pet.playfulness, icon: "balloon")
                    ratingView(title: "Grooming", value: pet.grooming, icon: "comb")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                FavoriteButton(pet: pet)
                    .environment(\.managedObjectContext, context)
            }
        }
        .sheet(isPresented: $showFullImage) {
            FullImageView(imageUrl: pet.image_link)
        }
    }
    
    private func ratingView(title: String, value: Int, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
                Spacer()
                Text(ratingDescription(for: value))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Circle()
                        .fill(index <= value ? Color.accentColor : Color.gray.opacity(0.3))
                        .frame(width: 12, height: 12)
                }
            }
        }
    }
    
    private func ratingDescription(for value: Int) -> String {
        switch value {
        case 1:
            return "Very low"
        case 2:
            return "Low"
        case 3:
            return "Moderate"
        case 4:
            return "High"
        case 5:
            return "Very high"
        default:
            return "Unknown"
        }
    }
}

struct FavoriteButton: View {
    let pet: Pet
    @Environment(\.managedObjectContext) private var context
    @State private var isFavorite: Bool = false
    
    var body: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .primary)
                .contentShape(Rectangle()) // Makes entire area tappable
        }
        .onAppear {
            checkFavoriteStatus()
        }
        .onChange(of: pet) { _ in
            checkFavoriteStatus()
        }
    }
    
    private func checkFavoriteStatus() {
        let request = FavoritePet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", pet.name)
        
        do {
            let results = try context.fetch(request)
            isFavorite = !results.isEmpty
        } catch {
            print("Error checking favorite status: \(error)")
            isFavorite = false
        }
    }
    
    private func toggleFavorite() {
        let request = FavoritePet.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", pet.name)
        
        do {
            let results = try context.fetch(request)
            
            if let existingFavorite = results.first {
                context.delete(existingFavorite)
                isFavorite = false
            } else {
                let newFavorite = FavoritePet(context: context)
                newFavorite.fromPet(pet)
                isFavorite = true
            }
            
            try context.save()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let testPet = Pet(name: "Fluffy", image_link: "https://api-ninjas.com/images/dogs/affenpinscher.jpg", type: .cat, shedding: 3, playfulness: 3, grooming: 5)
        
        return NavigationStack {
            PetDetailView(pet: testPet)
                .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
        }
    }
}
