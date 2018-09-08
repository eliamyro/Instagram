//
//  CustomImageView.swift
//  Instagram
//
//  Created by Elias Myronidis on 07/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    var lastUrlUsedToLoadImage: String?
    fileprivate var imageCache = [String: UIImage]()
    
    func loadImage(urlString: String) {
        lastUrlUsedToLoadImage = urlString
        
        if let cachedImage = imageCache[urlString] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to fetch image: ", error.localizedDescription)
                return
            }
            
            if url.absoluteString != self.lastUrlUsedToLoadImage { return }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            self.imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
        }.resume()
    }
}
