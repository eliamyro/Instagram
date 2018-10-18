//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Elias Myronidis on 30/08/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

protocol UserProfileHeaderDelegate: class {
    func didChangeToGridView()
    func didChangeToListView()
}


class UserProfileHeader: UICollectionReusableView {
    
    weak var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: url)
            usernameLabel.text = user?.username
            
            setupEditFollowButton()
        }
    }
    
    lazy var profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 80/2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        
        button.addTarget(self, action: #selector(handleChangeToGridView), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor.lightGray
        
        button.addTarget(self, action: #selector(handleChangeToListView), for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor.lightGray
        
        return button
    }()
    
    lazy var topDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    lazy var postsLabel: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))

        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [profileImageView, usernameLabel, editProfileFollowButton].forEach { addSubview($0) }
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        setupBottomToolbar()
    
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: topDividerView.topAnchor, trailing: nil, padding: .init(top: 4, left: 12, bottom: 0, right: 0))
        
        setupUserStatsView()
        
        editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor, bottom: nil, trailing: followingLabel.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 34))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBottomToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        [stackView, topDividerView, bottomDividerView].forEach { addSubview($0) }

        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 50))
        topDividerView.anchor(top: nil, leading: leadingAnchor, bottom: stackView.topAnchor, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
        bottomDividerView.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 0.5))
    }
    
    fileprivate func setupUserStatsView() {
        let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 12, bottom: 0, right: 12), size: .init(width: 0, height: 50))
    }
    
    @objc fileprivate func handleEditProfileOrFollow() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
            // Edit profile
        } else {
            guard let buttonText = editProfileFollowButton.titleLabel?.text else { return }
            
            if buttonText == "Follow" {
                // Follow
                let values = [userId: 1]
                let reference = Database.database().reference().child("following").child(currentLoggedInUserId)
                reference.updateChildValues(values) { (error, reference) in
                    if let error = error {
                        print("Failed to follow user: ", error)
                        return
                    }
        
                    self.setupUnfollowStyle()
                }
            } else {
                // Unfollow
                Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).removeValue { (error, reference) in
                    if let error = error {
                        print("Failed to remove following of the user: ", error.localizedDescription)
                        return
                    }
                    
                    self.setupFollowStyle()
                }
            }
        }
    }
    
    @objc fileprivate func handleChangeToListView() {
        listButton.tintColor = Colors.mainBlue
        gridButton.tintColor = UIColor.lightGray
        delegate?.didChangeToListView()
    }
    
    @objc fileprivate func handleChangeToGridView() {
        gridButton.tintColor = Colors.mainBlue
        listButton.tintColor = UIColor.lightGray
        delegate?.didChangeToGridView()
        
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        
        if currentLoggedInUserId == userId {
           // Edit profile
        } else {
            Database.database().reference().child("following").child(currentLoggedInUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1{
                    self.setupUnfollowStyle()
                } else {
                    self.setupFollowStyle()
                }
            }) { (error) in
                print("Failed to get following user: ", error.localizedDescription)
            }
        }
    }
    
    fileprivate func setupFollowStyle() {
        editProfileFollowButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        editProfileFollowButton.setTitleColor(UIColor.white, for: .normal)
        editProfileFollowButton.setTitle("Follow", for: .normal)
    }
    
    fileprivate func setupUnfollowStyle() {
        editProfileFollowButton.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        editProfileFollowButton.setTitleColor(UIColor.black, for: .normal)
        editProfileFollowButton.setTitle("Unfollow", for: .normal)
    }
}
