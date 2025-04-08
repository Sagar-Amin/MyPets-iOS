//
//  PetRow.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct PetRow: View {
    let pet: Pet
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: pet.image_link)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(pet.name)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: pet.type == .dog ? "dog" : "cat")
                .foregroundColor(.brown)
        }
    }
}

struct PetRow_Previews: PreviewProvider {
    static var previews: some View {
        let testPet = Pet(name: "Fluffy", image_link: "https://api-ninjas.com/images/dogs/affenpinscher.jpg", type: .cat, shedding: 3, playfulness: 3, grooming: 5)
        return PetRow(pet: testPet)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
