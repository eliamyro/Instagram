//
//  CommentsCell.swift
//  Instagram
//
//  Created by Elias Myronidis on 06/10/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

class CommentsCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            let attributedText = NSMutableAttributedString(string: comment.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            commentTextView.attributedText = attributedText
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    lazy var profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 40, height: 40))
        profileImageView.layer.cornerRadius = 40 / 2
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
