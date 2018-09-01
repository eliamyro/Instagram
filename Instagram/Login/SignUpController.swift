//
//  ViewController.swift
//  Instagram
//
//  Created by Elias Myronidis on 30/08/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    private let notificationKey = "com.eliamyro.instagram.notificationkey"
    private var db: Firestore!
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handlePlusButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleSignUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleLoginShow), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        view.backgroundColor = .white
        
        [plusPhotoButton, alreadyHaveAccountButton].forEach { view.addSubview($0) }
       
        plusPhotoButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        alreadyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 30))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 200))
    }
    
    @objc private func handleSignUpButtonPressed() {
        print("Sign up button pressed!")
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to create user", error.localizedDescription)
                return
            }
            
            print("User succesfully created: ", result?.user.uid ?? "")
            
            guard let uid = result?.user.uid else { return }
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print("Failed to save image to storage: ", error.localizedDescription)
                    return
                }
                
                print("Image saved to firebase storage.")
                
                storageRef.downloadURL(completion: { (downloadUrl, error) in
                    if let error = error {
                        print("Failed to download url: ", error.localizedDescription)
                        return
                    }
                    
                    guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                    
                    let userDictionary = ["username": username, "profileImageUrl": profileImageUrl]
                    
                    self.db.collection("users").document(uid).setData(userDictionary, completion: { (error) in
                        if let error = error {
                            print("Failed to save user to Firebase: ", error.localizedDescription)
                            return
                        }
                        
                        print("User saved succesfully to Firebase database.")
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.notificationKey), object: self)
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc private func handleLoginShow() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    
    @objc private func handlePlusButtonPressed() {
        print("plus button pressed!")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        picker.dismiss(animated: true, completion: nil)
    }


}

