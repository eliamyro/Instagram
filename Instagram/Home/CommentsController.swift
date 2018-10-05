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
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .red
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
        
        commentsTextField.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        submitButton.anchor(top: container.topAnchor, leading: nil, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 0))
        
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
            
            print("Successfully saved comment!")
        }
    }
}
