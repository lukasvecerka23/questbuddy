//
//  LoginService.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 26.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginService: ObservableObject {
    // When is set store it to UserDefaults to stay logged after application is exited
    @Published var  isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(self.isLoggedIn, forKey: "UserLoggedIn")
        }
    }
    
    // Appear loading view
    @Published var isLogging: Bool = false
    
    init(){
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "UserLoggedIn")
    }
    
    // Login to firebase
    func LogIn(email: String, password: String, completion: @escaping (Bool, Error?) -> ()){
        self.isLogging = true
        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
            self.isLogging = false
            if let error = error {
                completion(false, error)
            } else {
                // fetch all user data
                UserModel.shared.fetchUserData()
                HabitsModel.shared.loadAllData()
                self.isLoggedIn = true
                completion(true, nil)
            }
        }
    }
    
    func LogOut(completion: @escaping (Bool) -> ()){
        do {
            try Auth.auth().signOut()
            UserModel.shared.clearUser()
            HabitsModel.shared.clearModel()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func Register(email: String, password: String, username: String, completion: @escaping (Bool, Error?) -> ()){
        self.isLogging = true // show loading screen
        // Create new user
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            if let error = error {
                self.isLogging = false
                completion(false, error)
            }
            guard let user = authResult?.user else {return}
            
            let db = Firestore.firestore()
            
            // Create new document in Firestore with default values for user
            db.collection("users").document(user.uid).setData(["username": username, "points": 0]){ error in
                if let error = error {
                    self.isLogging = false
                    completion(false, error)
                }
                
            }
            // everything okay
            UserModel.shared.fetchUserData()
            HabitsModel.shared.loadAllData()
            self.isLoggedIn = true
            self.isLogging = false
            completion(true, nil)
        }
    }
}
