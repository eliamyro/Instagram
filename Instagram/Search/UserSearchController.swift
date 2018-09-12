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
    
    lazy var userSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        searchBar.delegate = self
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        let navBar = navigationController?.navigationBar
        
        navBar?.addSubview(userSearchBar)
        userSearchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: CELL_ID)
        
        collectionView.alwaysBounceVertical = true
        
        fetchUsers()
    }
    
    fileprivate func fetchUsers() {
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
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
