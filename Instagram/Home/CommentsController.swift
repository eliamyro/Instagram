//
//  CommentsController.swift
//  Instagram
//
//  Created by Elias Myronidis on 05/10/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {
    
    fileprivate let cellId = "cellId"
    
    var post: Post?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        
        collectionView.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        container.backgroundColor = .white
        
        container.addSubview(commentsTextField)
        container.addSubview(submitButton)
        container.addSubview(separator)
        
        commentsTextField.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        submitButton.anchor(top: container.topAnchor, leading: nil, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 0))
        separator.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: container.trailingAnchor, size: .init(width: 0, height: 0.5))
        
        return container
    }()
    
    lazy var commentsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        
        return textField
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        return button
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    @objc fileprivate func handleSubmitButton() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = post?.id ?? ""
        let values: [String: Any] = ["text": commentsTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
            if let error = error {
                print("Failed to save comment: ", error.localizedDescription)
                return
            }
            
            self.commentsTextField.resignFirstResponder()
            self.commentsTextField.text = ""
            print("Successfully saved comment!")
        }
    }
    
    fileprivate func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Failed to observe comments")
        }
    }
}

extension CommentsController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        cell.comment = comments[indexPath.item]
        return cell
    }
}

extension CommentsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentsCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(56, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
