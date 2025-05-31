iOS application that enables users to browse and select their favorite pets (cat/dog) along with detailed descriptions.
It also features a map view integration that displays all pet shelters across New Jersey.
	
- Technology
	1) MVVC Archtecture
		- Model 
		   definded 3 models (pet, shelter, user)
		   struct pet {
				let name: String		// name
				let image_link: String	// image url
				var type: PetType		// type (cat or dog)
				let shedding: Int		
				let playfulness: Int
				let grooming: Int
			}
			
			struct shelter {
				let id = UUID()			// id
				let name: String		// name
				let address: String		// address
				let coordinate: CLLocationCoordinate2D  // langitude and longitude of address
			}
			
			struct user {
				let name: String		// name
				let email: String		// email
				let password: String	// password
			}
	2) Network Manager
		Using 'URLSession' library to call 3rd party apis 
		
		dog api: https://api.api-ninjas.com/v1/dogs
		cat api: https://api.api-ninjas.com/v1/cats
		
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
	
	3) Firebase Authentication
		Used firebase  auth for user management,
		there are login and signup, logout
		
			
			func checkAuthStatus() -> AnyPublisher<Bool, Error> {
				Future<Bool, Error> { promise in
					Auth.auth().addStateDidChangeListener { _, user in
						promise(.success(user != nil))
					}
				}
				.eraseToAnyPublisher()
			}
			
			func login(email: String, password: String) -> AnyPublisher<Void, Error> {
				Future<Void, Error> { promise in
					Auth.auth().signIn(withEmail: email, password: password) { result, error in
						if let error = error {
							promise(.failure(error))
						} else {
							promise(.success(()))
						}
					}
				}
				.eraseToAnyPublisher()
			}
			
			func signUp(email: String, password: String) -> AnyPublisher<Void, Error> {
				Future<Void, Error> { promise in
					Auth.auth().createUser(withEmail: email, password: password) { result, error in
						if let error = error {
							promise(.failure(error))
						} else {
							promise(.success(()))
						}
					}
				}
				.eraseToAnyPublisher()
			}
			
			func logout() -> AnyPublisher<Void, Error> {
				Future<Void, Error> { promise in
					do {
						try Auth.auth().signOut()
						promise(.success(()))
					} catch {
						promise(.failure(error))
					}
				}
				.eraseToAnyPublisher()
			}
			
	4) CoreData
		Used NSPersistentContainer for container and implemented saveContext() function in it
			class CoreDataManager {
		
