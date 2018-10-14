//
//  Post.swift
//  Instagram
//
//  Created by Elias Myronidis on 07/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import Foundation

struct Post {
    
    var id: String?
    
    let user: User
    let imageUrl: String
    let caption: String
    let creationDate: Date
    
    var isLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
