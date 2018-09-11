//
//  UserSearchController.swift
//  Instagram
//
//  Created by Elias Myronidis on 11/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
    
    let CELL_ID = "cellId"
    
    let userSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter username"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
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
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_ID, for: indexPath) as! UserSearchCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
}
