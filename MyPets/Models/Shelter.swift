//
//  Shelter.swift
//  MyPets
//
//  Created by Sagar Amin on 3/28/25.
//
import SwiftUI
import MapKit

struct Shelter: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
}

