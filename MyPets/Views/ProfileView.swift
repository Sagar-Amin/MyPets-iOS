//
//  ProfileView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/28/25.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Profile Icon
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .padding(.top, 40)
                
                // User Email
                Text(authVM.currentUserEmail)
                    .font(.title2)
                    .padding()
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("Log Out")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding()
            }
            .navigationTitle("Profile")
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Log Out", role: .destructive) {
                    authVM.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
