//
//  SignUpView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI
// View responsible for user registration, connected to AuthenticationViewModel
struct SignUpView: View {
    // Access the shared AuthenticationViewModel via environment
    @EnvironmentObject var authVM: AuthenticationViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.title.bold())
                .foregroundColor(.accentColor)
            
            VStack(spacing: 16) {
                UIKitTextField(
                    text: $authVM.email,
                    placeholder: "Email",
                    keyboardType: .emailAddress
                )
                .frame(height: 44)
                
                UIKitTextField(
                    text: $authVM.password,
                    placeholder: "Password",
                    isSecure: true
                )
                .frame(height: 44)
                
                // Show validation or API errors
                if let errorMessage = authVM.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: authVM.signUp) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(authVM.email.isEmpty || authVM.password.isEmpty)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline) // Keeps title compact in nav bar    }
    }
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                SignUpView()
                    .environmentObject(AuthenticationViewModel())
            }
        }
    }
}
