//
//  Post.swift
//  Instagram
//
//  Created by Elias Myronidis on 07/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import Foundation

struct Post {
    
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
