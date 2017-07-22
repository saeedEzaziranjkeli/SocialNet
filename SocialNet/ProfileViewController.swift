//
//  ProfileViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 18/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit

class ProfileViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBAction func unwindMessageController(seque:UIStoryboardSegue){
        
    }
    @IBAction func addPicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
