//
//  UserProfileHeader.swift
//  Instagram
//
//  Created by Elias Myronidis on 30/08/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

class UserProfileHeader: UICollectionReusableView {
    
    var user: User? {
        didSet {
            guard let url = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: url)
            usernameLabel.text = user?.username
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.layer.cornerRadius = 80/2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor.lightGray
        
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor.lightGray
        
        return button
    }()
    
    let topDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let bottomDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let postsLabel: UILabel = {
        let label = UILabel()

        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))

        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [.foregroundColor: UIColor.lightGray, .font: UIFont.boldSystemFont(ofSize: 14)]))
        
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [profileImageView, usernameLabel, editProfileButton].forEach { addSubview($0) }
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        
        setupBottomToolbar()
    
        usernameLabel.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: topDividerView.topAnchor, trailing: nil, padding: .init(top: 4, left: 12, bottom: 0, right: 0))
        
        setupUserStatsView()
        
        editProfileButton.anchor(top: postsLabel.bottomAnchor, leading: postsLabel.leadingAnchor, bottom: nil, trailing: followingLabel.trailingAnchor, padding: .init(top: 2, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 34))
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
}
