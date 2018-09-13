//
//  FirebaseExtensions.swift
//  Instagram
//
//  Created by Elias Myronidis on 11/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping(User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
        }) { (error) in
            print("Failed to fetch user: ", error.localizedDescription)
        }
    }
}
