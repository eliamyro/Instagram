//
//  PreviewPhotoContainerView.swift
//  Instagram
//
//  Created by Elias Myronidis on 03/10/2018.
//  Copyright © 2018 Elias Myronidis. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    var previewImage: UIImage? {
        didSet {
            guard let previewImage = previewImage else { return }
            previewPhotoImageView.image = previewImage
        }
    }
    
    lazy var previewPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
       
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
       
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
        
        addSubview(previewPhotoImageView)
        previewPhotoImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        addSubview(cancelButton)
        cancelButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        addSubview(saveButton)
        saveButton.anchor(top: nil, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 8, right: 0), size: .init(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: PreviewPhotoContainerView methods
    
    @objc fileprivate func handleCancelButton() {
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handleSaveButton() {
        print("Saving photo...")
        
        guard let previewImage = previewImage else { return }
        let photoLibrary = PHPhotoLibrary.shared()
        
        photoLibrary.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success, error) in
            if let error = error {
                print("Failed to save image to photo library: ", error.localizedDescription)
                return
            }
            
            print("Successfully saved image to library.")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved Successfully"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.numberOfLines = 0
                savedLabel.textColor = .white
                savedLabel.textAlignment = .center
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                self.addSubview(savedLabel)
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed) in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }, completion: { (completed) in
                        savedLabel.removeFromSuperview()
                    })
                })
            }
        }
    }
}
