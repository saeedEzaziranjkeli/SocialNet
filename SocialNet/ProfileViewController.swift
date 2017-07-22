//
//  ProfileViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 18/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
class ProfileViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBAction func addPicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var usernameTitle: UILabel!
    
    override func viewDidLoad() {
        self.usernameTitle.text = " "
        super.viewDidLoad()
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                    let username = auth.currentUser?.displayName
                    self.usernameTitle.text = username
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    self.profileImageView.image = UIImage(data: data! as Data)
            }
            else{
                print("User must Signin")
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImageView.image = image;
                }
        else{
            print("Image has Problem")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
