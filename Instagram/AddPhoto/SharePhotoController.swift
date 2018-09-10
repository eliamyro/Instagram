//
//  SharePhotoController.swift
//  Instagram
//
//  Created by Elias Myronidis on 05/09/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            photoImage.image = selectedImage
        }
    }
    
    let photoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
       
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare)), animated: true)
        
        setupImageAndTextView()
    }
    
    fileprivate func setupImageAndTextView() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 100))
        
        containerView.addSubview(photoImage)
        photoImage.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: 84, height: 0))
        
        containerView.addSubview(captionTextView)
        captionTextView.anchor(top: containerView.topAnchor, leading: photoImage.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    @objc fileprivate func handleShare() {
        guard let caption = captionTextView.text, caption.count > 0 else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(filename)
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Failed to save image to firestore storage", error.localizedDescription)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }

            storageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Failed to get the download url: ", error.localizedDescription)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }
                print("Successfully uploaded post image")
                
                self.saveToDatabaseWithImageUrl(imageUrl: imageUrl)
            })
        }
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let postImage = selectedImage else { return }
        guard let caption = captionTextView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values: [String: Any] = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970]
        
        let reference = Database.database().reference().child("posts").child(uid).childByAutoId()
        reference.updateChildValues(values) { (error, reference) in
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to database: ", error.localizedDescription)
            }
            
            print("Post saved successfully to database")
            self.dismiss(animated: true, completion: nil)
        }
    }
}

