//
//  AuthServiceTests.swift
//  MyPets
//
//  Created by Sagar Amin on 3/29/25.
//

import XCTest
import Combine
import FirebaseAuth
@testable import MyPets

class AuthServiceTests: XCTestCase {
    var authService: AuthService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        authService = AuthService()
        cancellables = []
        
        // Sign out before each test
        try? Auth.auth().signOut()
    }
    
    override func tearDown() {
        authService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testCheckAuthStatusWhenNotLoggedIn() {
        let expectation = XCTestExpectation(description: "Check auth status completes")
        
        authService.checkAuthStatus()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { isAuthenticated in
                XCTAssertFalse(isAuthenticated, "Should not be authenticated")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoginWithInvalidCredentials() {
        let expectation = XCTestExpectation(description: "Login completes")
        
        authService.login(email: "invalid@example.com", password: "wrongpassword")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Login should fail with invalid credentials")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testSignUpAndLogin() {
        let randomEmail = "test\(Int.random(in: 1...10000))@example.com"
        let password = "password123"
        
        let signUpExpectation = XCTestExpectation(description: "Sign up completes")
        let loginExpectation = XCTestExpectation(description: "Login completes")
        
        // Create a single subscription that handles both operations
        authService.signUp(email: randomEmail, password: password)
            .flatMap { signUpResult in
                // Fulfill signup expectation when signup completes
                signUpExpectation.fulfill()
                return self.authService.login(email: randomEmail, password: password)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in
                loginExpectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [signUpExpectation, loginExpectation], timeout: 20.0)
    }
}
