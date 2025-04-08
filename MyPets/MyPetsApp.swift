//
//  MyPetsApp.swift
//  MyPets
//
//  Created by Sagar Amin on 3/25/25.
//

import SwiftUI
import FirebaseCore
import CoreData

@main
struct MyPetsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        private let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

