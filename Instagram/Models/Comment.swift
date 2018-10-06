//
//  Comment.swift
//  Instagram
//
//  Created by Elias Myronidis on 06/10/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import Foundation

struct Comment {
    
    let text: String
    let creationDate: Date
    let uid: String
    
    init(dictionary: [String: Any]) {
        text = dictionary["text"] as? String ?? ""
        let secondFrom1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: secondFrom1970)
        uid = dictionary["uid"] as? String ?? ""
    }
}
