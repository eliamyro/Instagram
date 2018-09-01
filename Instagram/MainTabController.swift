//
//  MainTabController.swift
//  Instagram
//
//  Created by Elias Myronidis on 30/08/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    private let notificationKey = "com.eliamyro.instagram.notificationkey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupViewControllers), name: NSNotification.Name(rawValue: notificationKey), object: nil)
        
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            let navigationController = UINavigationController(rootViewController: loginController)
            
            DispatchQueue.main.async {
                self.present(navigationController, animated: true, completion: nil)
            }
            
            return
        }
        
        setupViewControllers()
    }
    
    @objc func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: userProfileController)
        
        navigationController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        navigationController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [navigationController, UIViewController()]
    }
}
