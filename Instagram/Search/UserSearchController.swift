//
//  UserSearchController.swift
//  Instagram
//
//  Created by Elias Myronidis on 11/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController {
    
    let CELL_ID = "cellId"
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter username"
        searchController.searchBar.barStyle = .blackTranslucent
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        searchController.searchBar.delegate = self
    
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
    
        navigationItem.titleView = searchController.searchBar
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid { return }
                guard let userDictionary  = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }) { (error) in
            print("Failed to fetch users: ", error.localizedDescription)
        }
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    // MARK: - CollectionViewDelegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(filteredUsers)
        let user = filteredUsers[indexPath.item]
       print(user.username)
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        print(user.uid)
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    // MARK: - CollectionViewDelegateFlowLayour methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
    // MARK: - SearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.isEmpty {
            self.filteredUsers = self.users
        } else {
            filteredUsers = users.filter { (user) -> Bool in
                user.username.lowercased().contains(searchText.lowercased())
            }
        }
        
        self.collectionView.reloadData()
    }
}
