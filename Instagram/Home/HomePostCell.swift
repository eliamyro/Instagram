//
//  HomePostCell.swift
//  Instagram
//
//  Created by Elias Myronidis on 08/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

protocol HomePostDelegate: class {
    func didTapComment(post: Post)
    func didTapLike(postCell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    weak var delegate: HomePostDelegate?
    
    var post: Post? {
        didSet {
            guard let url = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: url)
            
            guard let username = post?.user.username else { return }
            usernameLabel.text = username
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }
            userProfileImageView.loadImage(urlString: profileImageUrl)
            
            likeButton.setImage(post?.isLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            setupAttributedCaption()
        }
    }
    
    lazy var userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    lazy var photoImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handleCommentsButton), for: .touchUpInside)
        return button
    }()
    
    lazy var sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        
        return button
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        
        userProfileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        userProfileImageView.layer.cornerRadius = 40/2
        userProfileImageView.clipsToBounds = true
        
        usernameLabel.anchor(top: topAnchor, leading: userProfileImageView.trailingAnchor, bottom: photoImageView.topAnchor, trailing: optionsButton.leadingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        
        optionsButton.anchor(top: topAnchor, leading: nil, bottom: photoImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 44, height: 0))
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 0))
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(bookmarkButton)
        addSubview(captionLabel)
        
        stackView.anchor(top: photoImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 4, bottom: 0, right: 0), size: .init(width: 120, height: 50))
        
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 40, height: 50))
        
        captionLabel.anchor(top: stackView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 4))
    }
    
    fileprivate func setupAttributedCaption() {
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        captionLabel.attributedText = attributedText
    }
    
    @objc fileprivate func handleCommentsButton() {
        guard let post = post else { return }
        delegate?.didTapComment(post: post)
    }
    
    @objc fileprivate func handleLikeButton(){
        delegate?.didTapLike(postCell: self)
    }
}
