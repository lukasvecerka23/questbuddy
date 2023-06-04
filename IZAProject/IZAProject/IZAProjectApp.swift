//
//  IZAProjectApp.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 19.02.2023.
//

import SwiftUI
import FirebaseCore

@main
struct IZAProjectApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LandingPage().environmentObject(LoginService())
        }
        
    }
}
