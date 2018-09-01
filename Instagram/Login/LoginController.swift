//
//  LoginController.swift
//  Instagram
//
//  Created by Elias Myronidis on 31/08/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    private let notificationKey = "com.eliamyro.instagram.notificationkey"
    
    let loginContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        
        let logoImageView = UIImageView()
        logoImageView.image = #imageLiteral(resourceName: "Instagram_logo_white")
        logoImageView.contentMode = .scaleAspectFit
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 50))

        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(handleLogginButton), for: .touchUpInside)
        return button
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
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleSingUpShow), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        [loginContainerView, dontHaveAccountButton].forEach { view.addSubview($0) }
        
        loginContainerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
        
        setupInputFields()
        
        dontHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 30))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc fileprivate func handleSingUpShow() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    @objc private func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
            loginButton.isEnabled = false
        }
    }
    
    @objc fileprivate func handleLogginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Failed to sign in with email: ", error.localizedDescription)
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.notificationKey), object: self)
            
//            let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
//            mainTabBarController?.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: loginContainerView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: 40, bottom: 0, right: 40), size: .init(width: 0, height: 140))
    }
}
