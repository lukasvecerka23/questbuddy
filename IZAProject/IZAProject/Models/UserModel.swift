//
//  UserModel.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 29.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// User statistics
struct UserStats{
    var completedHabits: Int = 0
    var createdHabits: Int = 0
    var completedDuration: Int = 0
}

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var points: Int
}

class UserModel: ObservableObject{
    static var shared = UserModel()
    
    @Published var user: User? = nil
    @Published var userStats: UserStats = UserStats()
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    private init() {
        fetchUserData()
    }
    
    // Create listener for user data
    func fetchUserData(){
        listener?.remove()
        listener = db.collection("users").document(Auth.auth().currentUser?.uid ?? "").addSnapshotListener{ (querySnapshot, error) in
            guard let document = querySnapshot else {
                return
            }
            
            guard document.data() != nil else {
                return
            }
            
            if let user = try? document.data(as: User.self){
                self.user = user
            }
        }
    }
    
    func clearUser(){
        self.user = nil
        listener?.remove()
    }
    
    // Update user's points after habit check in or check out
    func updateUserPoints(points: Int) {
        self.user?.points += points
        guard let userPoints = self.user?.points else {
            return
        }
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData([
            "points": userPoints
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            }
        }
    }
    
    func updateEmail(to newEmail: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
            guard let email = Auth.auth().currentUser?.email else {
                return
            }
            let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
            
            if let user = Auth.auth().currentUser {
                // reauntehticate
                user.reauthenticate(with: credentials) { authResult, error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        // update email
                        user.updateEmail(to: newEmail) {error in
                            if let error = error{
                                completion(false, error)
                            } else {
                                completion(true, nil)
                            }
                        }
                    }
                }
            }
        }
        
    func updatePassword(to newPassword: String, password: String, completion: @escaping (Bool, Error?) -> ()) {
            guard let email = Auth.auth().currentUser?.email else {
                return
            }
            let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
            
            if let user = Auth.auth().currentUser {
                // reauthenticate
                user.reauthenticate(with: credentials) { authResult, error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        // update password
                        user.updatePassword(to: newPassword) { error in
                            if let error = error{
                                completion(false, error)
                            }else {
                                completion(true, nil)
                            }
                        }
                    }
                }
            }
        }
        
    func updateUsername(to newUsername: String, completion: @escaping (Bool, Error?) -> ()) {
            guard let userId = Auth.auth().currentUser?.uid else {
                return
            }
            
            db.collection("users").document(userId).updateData([
                "username": newUsername
            ]) { error in
                if let error = error{
                    completion(false, error)
                }else {
                    completion(true, nil)
                }
            }
        }
    
    func deleteUserData(userId: String, completion: @escaping (Bool, Error?) -> ()){
        self.db.collection("users").document(userId).delete() { err in
            if let err = err {
                completion(false, err)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func deleteUserHabits(userId: String, completion: @escaping (Bool, Error?) -> ()){
        self.db.collection("habits")
            .whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false, err)
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    completion(true, nil)
                }
            }
    }
    
    func deleteUsersHabitLog(userId: String, completion: @escaping (Bool, Error?) -> ()) {
        self.db.collection("habitLog")
            .whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    completion(false, err)
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    completion(true, nil)
                }
            }
    }
    
    func deleteAccount(completion: @escaping (Bool, Error?) -> ()){
        Auth.auth().currentUser?.delete { (error) in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
    }
    
    func deleteUser(password: String, completion: @escaping (Bool, Error?) -> ()){
        guard let email = Auth.auth().currentUser?.email else {
            return
        }
        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
        
        if let user = Auth.auth().currentUser{
            // reauthenticate
            user.reauthenticate(with: credentials){authResult, error in
                if let error = error{
                    completion(false, error)
                } else {
                    // delete user data
                    self.deleteUserData(userId: user.uid){succ, err in
                        if succ{
                            // delete user habits
                            self.deleteUserHabits(userId: user.uid) { succ, err in
                                if succ {
                                    // delete user habit log
                                    self.deleteUsersHabitLog(userId: user.uid) { succ, err in
                                        if succ {
                                            // delete account
                                            self.deleteAccount(){succ, err in
                                                if succ{
                                                    completion(true, nil)
                                                }
                                                if let err = err {
                                                    completion(false, err)
                                                }
                                            }
                                            //
                                        }
                                        if let err = err {
                                            completion(false, err)
                                        }
                                        //
                                    }
                                }
                                if let err = err {
                                    completion(false, err)
                                }
                                //
                            }
                        }
                        if let err = err {
                            completion(false, err)
                        }
                        //
                    }
                    
                }
            }
        }
    }
}
