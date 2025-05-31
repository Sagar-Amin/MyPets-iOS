
# MyPets

MyPets is an iOS application that enables users to browse and select their favorite pets (cat/dog) along with detailed descriptions. It also features a map view integration that displays all pet shelters across New Jersey.

---

## 🛠 Technology Stack

### 1. MVVC Architecture

**Model:**

```swift
struct Pet {
    let name: String           // name
    let image_link: String     // image url
    var type: PetType          // type (cat or dog)
    let shedding: Int
    let playfulness: Int
    let grooming: Int
}

struct Shelter {
    let id = UUID()            // id
    let name: String           // name
    let address: String        // address
    let coordinate: CLLocationCoordinate2D // latitude and longitude
}

struct User {
    let name: String           // name
    let email: String          // email
    let password: String       // password
}
```

---

### 2. Network Manager

Using `URLSession` to fetch data from third-party APIs:

- **Dog API:** https://api.api-ninjas.com/v1/dogs  
- **Cat API:** https://api.api-ninjas.com/v1/cats

```swift
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
                modifiedPet.type = Pet.PetType.dog
                return modifiedPet
            }
        }
        .eraseToAnyPublisher()
}
```

---

### 3. Firebase Authentication

Using Firebase Authentication for user management (login, signup, logout):

```swift
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
```

---

### 4. Core Data

Using `NSPersistentContainer` and implementing `saveContext()`:

```swift
class CoreDataManager {
    // Implementation continues...
}
```

---

## 📍 Features

- Browse detailed pet info (cats and dogs)
- Favorite and compare pets
- View shelter locations on the map across New Jersey
- User authentication via Firebase
- Persistent storage using Core Data

---




