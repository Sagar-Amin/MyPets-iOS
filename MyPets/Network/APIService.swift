//
//  APIService.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import Foundation
import Combine

struct APIService {
    private let apiKey = "DOT4Dskst6qezg9rU0F/zg==SRXFD139Yz9Dys4H"
    private let baseURL = "https://api.api-ninjas.com/v1/"
    
    // dog : baseURL + /dogs
    // cat : baseURL + /cats
    
    func fetchDogs() -> AnyPublisher<[Pet], Error> {
        let url = URL(string: baseURL + "dogs?name=a")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Pet].self, decoder: JSONDecoder())
            .map { pets in
                
                pets.map { pet in
                    var modifiedPet = pet
                    // modifiedPet.details?["type"] = "dog"
                    modifiedPet.type = Pet.PetType.dog
                    return modifiedPet
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCats() -> AnyPublisher<[Pet], Error> {
        let url = URL(string: baseURL + "cats?name=a")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Pet].self, decoder: JSONDecoder())
            .map { pets in
                pets.map { pet in
                    var modifiedPet = pet
                    // modifiedPet.details?["type"] = "cat"
                    modifiedPet.type = Pet.PetType.cat
                    return modifiedPet
                }
            }
            .eraseToAnyPublisher()
    }
}
