//
//  AuthViewModel.swift
//  FirebaseDemo
//
//  Created by Sagar Amin on 3/26/25.
//

import FirebaseAuth
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    
    var currentUserEmail: String {
        Auth.auth().currentUser?.email ?? "No user logged in"
    }
    
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthentication()
    }
    
    func checkAuthentication() {
        authService.checkAuthStatus()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { isAuthenticated in
                self.isAuthenticated = isAuthenticated
            }
            .store(in: &cancellables)
    }
    
    func login() {
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.isAuthenticated = true
                self.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func signUp() {
        authService.signUp(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.isAuthenticated = true
                self.errorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        authService.logout()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { _ in
                self.isAuthenticated = false
                self.email = ""
                self.password = ""
                self.errorMessage = nil
            }
            .store(in: &cancellables)
    }
}
