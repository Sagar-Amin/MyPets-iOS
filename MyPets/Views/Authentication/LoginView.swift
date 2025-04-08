//
//  LoginView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var isSignUpActive = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("loginBackground") // Make sure to add this to your assets
                    .resizable()
//                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.black.opacity(0.5)) // Dark overlay for better text visibility
                
                VStack(spacing: 20) {
                    // Custom app title with animated pawprints and gradient styling
//                    Text("My Pets")
//                        .font(.largeTitle.bold())
//                        .foregroundColor(.accentColor)
//                        .padding(.bottom, 100)
                    HStack(spacing: 8) {
                        Image(systemName: "pawprint.fill")
                            .font(.title)
                            .rotationEffect(.degrees(-30))
                        
                        Text("My Pets")
                            .font(.custom("Marker Felt", size: 36, relativeTo: .largeTitle))
                            .fontWeight(.bold)
                        
                        Image(systemName: "pawprint.fill")
                            .font(.title)
                            .rotationEffect(.degrees(30))
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .accentColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 3, x: 1, y: 1)
                    .padding(.bottom, 80)
                    
                    
                    VStack(spacing: 16) {
                        // Custom UIKit-powered email field
                        UIKitTextField(
                            text: $authVM.email,
                            placeholder: "Email",
                            keyboardType: .emailAddress
                        )
                        .frame(height: 44)
                        // Custom UIKit-powered password field
                        UIKitTextField(
                            text: $authVM.password,
                            placeholder: "Password",
                            isSecure: true
                        )
                        .frame(height: 44)
                        // Display error message if login fails
                        if let errorMessage = authVM.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        //Login Button
                        Button(action: authVM.login) {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .foregroundColor(.white)
                                .font(.headline)
                                .background(
                                    authVM.email.isEmpty || authVM.password.isEmpty ?
                                    Color.gray :
                                    Color.accentColor
                                )
                                .cornerRadius(8)
                        }
                        .disabled(authVM.email.isEmpty || authVM.password.isEmpty)
                        .animation(.easeInOut(duration: 0.2), value: authVM.email.isEmpty || authVM.password.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Don't have an account? Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
