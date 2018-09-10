//
//  HomeController.swift
//  Instagram
//
//  Created by Elias Myronidis on 08/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
    private let CELL_ID = "cellId"
    fileprivate var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        setupNavigationItems()
        fetchPosts()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        guard let userDictionary = snapshot.value as? [String: Any] else { return }
        let user = User(dictionary: userDictionary)
        
        let reference = Database.database().reference().child("posts").child(uid)
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            
            self.collectionView.reloadData()
            }) { (error) in
                print("Failed to fetch posts: ", error.localizedDescription)
            }
        }) { (error) in
            print("Failed to fetch user: ", error.localizedDescription)
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 56    // user profile image view
        height += view.frame.width  // photoImageView
        height += 110               // bottom actions view
        
        return CGSize(width: view.frame.width, height: height)
    }
}


