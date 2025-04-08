//
//  ContentView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/26/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var authVM = AuthenticationViewModel()
        
        var body: some View {
            Group {
                if authVM.isAuthenticated {
                    MainTabView()
                        .environmentObject(authVM)
                } else {
                    LoginView()
                        .environmentObject(authVM)
                }
            }
        }
}

