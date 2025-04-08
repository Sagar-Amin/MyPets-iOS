//
//  MainTabView.swift
//  MyPets
//
//  Created by Sagar Amin on 3/27/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Pets", systemImage: "pawprint")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            // MARK: - Shelters Tab (MapKit Integration)
            ShelterView()
               .tabItem {
                   Label("Shelters", systemImage: "map")
               }
            
            ProfileView()
               .tabItem {
                   Label("Profile", systemImage: "person.circle")
               }
        }
        
    }
}
