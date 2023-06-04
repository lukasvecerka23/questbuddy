//
//  RankingModel.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 29.05.2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class RankingModel: ObservableObject {
    static let shared = RankingModel()
    @Published var users: [User] = []
    
    private var db = Firestore.firestore()
    
    private var listener: ListenerRegistration?
    
    private init(){
        fetchData()
    }
    
    // Get all users and order them by points
    func fetchData(){
        listener?.remove()
        listener = db.collection("users").order(by: "points", descending: true).addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.users = documents.compactMap{ queryDocumentSnapshot -> User? in
                let data = queryDocumentSnapshot.data()

                guard let username = data["username"] as? String,
                      let points = data["points"] as? Int else {
                    return nil
                }

                return User(id: queryDocumentSnapshot.documentID, username: username, points: points)
            }
        }
    }
}
