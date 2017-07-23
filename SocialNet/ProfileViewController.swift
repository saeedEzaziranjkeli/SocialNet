//
//  ProfileViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 18/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseStorage

class ProfileViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var window:UIWindow?
    var ref: DatabaseReference!
    //var storage = Storage.storage(url:"gs://socialnet-91a2c.appspot.com/").reference()
    let storageRef = Storage.storage().reference()
    var userId:String!
    @IBAction func signoutButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }

    @IBAction func addPicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var usernameTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTitle.text = " "
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                self.userId = user?.uid ?? " nil"
                    let username = auth.currentUser?.displayName
                    self.usernameTitle.text = username
                
                let imagesRef = self.storageRef.child("images/"+self.userId + "/ProfileImage.jpg")
                imagesRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    if error == nil{
                        self.profileImageView.image = UIImage(data: data! as Data)
                    }
                    else{
                        let photoURL = auth.currentUser?.photoURL
                        let data = NSData(contentsOf: photoURL!)
                        self.profileImageView.image = UIImage(data: data! as Data)
                        print("Moshkel darad")
                    }
                })
                                }
            else{
                print("User must Signin")
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
               if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImageView.image = image;
                self.dismiss(animated: true, completion: nil)
                let imagesRef = storageRef.child("images/"+self.userId + "/ProfileImage.jpg")
            let metaDataObj = StorageMetadata()
            metaDataObj.contentType = "image/jpeg"
                imagesRef.putData(UIImageJPEGRepresentation(image, 0.0)!, metadata: metaDataObj, completion: { (data, error) in
                    if error != nil {
                        print(error?.localizedDescription ?? "dare")
                    }
                    else{
                        print("man okeyam")
                    }
                    let downloadURL = metaDataObj.downloadURLs
                    print(downloadURL)
                })
            
                }
        else{
            print("Image has Problem")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
