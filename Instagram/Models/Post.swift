//
//  Post.swift
//  Instagram
//
//  Created by Elias Myronidis on 07/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
    }
}
