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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: SharePhotoController.updateNotificationName, object: nil)
        
        setupNavigationItems()
        fetchPosts()
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        let cameraBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3"), style: .plain, target: self, action: #selector(handleCameraButton))
        navigationItem.leftBarButtonItem = cameraBarButton
    }
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
        
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key) { (user) in
                    self.fetchPostsWithUser(user: user)
                }
            })
            
        }) { (error) in
            print("Failed to fetch following users: ", error.localizedDescription)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        let reference = Database.database().reference().child("posts").child(user.uid)
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = key
                self.posts.append(post)
            })
            
            self.posts.sort(by: { (post1, post2) -> Bool in
               return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            
            self.collectionView.refreshControl?.endRefreshing()
            
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch posts: ", error.localizedDescription)
        }
    }
    
    @objc fileprivate func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    @objc fileprivate func handleCameraButton() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! HomePostCell
        if indexPath.item < posts.count {
            cell.post = posts[indexPath.item]
        }
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 56    // user profile image view
        height += view.frame.width  // photoImageView
        height += 110               // bottom actions view
        
        return CGSize(width: view.frame.width, height: height)
    }
}

extension HomeController: HomePostDelegate {
    func didTapComment(post: Post) {
        let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
}


