//
//  SettingController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 22/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userProfileImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.layer.borderWidth = 3
        userProfileImage.layer.masksToBounds = false
        userProfileImage.layer.borderColor = UIColor.white.cgColor
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height/2
        userProfileImage.clipsToBounds = true
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                let username = auth.currentUser?.displayName
                self.usernameLabel.text = username
                let photoURL = auth.currentUser?.photoURL
                let data = NSData(contentsOf: photoURL!)
                self.userProfileImage.image = UIImage(data: data! as Data)
            }
            else{
                print("User must Signin")
            }
        }

        
    }
}
