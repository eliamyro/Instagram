//
//  CommentsController.swift
//  Instagram
//
//  Created by Elias Myronidis on 05/10/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    
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
        
        let textField = UITextField()
        textField.placeholder = "Enter comment"
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        
        container.addSubview(textField)
        container.addSubview(submitButton)
        
        textField.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: submitButton.leadingAnchor, padding: .init(top: 0, left: 12, bottom: 0, right: 0))
        submitButton.anchor(top: container.topAnchor, leading: nil, bottom: container.bottomAnchor, trailing: container.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 0))
        
        return container
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    @objc fileprivate func handleSubmitButton() {
        print("Submiting comment!")
    }
}
