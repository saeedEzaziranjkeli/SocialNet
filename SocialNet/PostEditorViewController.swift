//
//  PostEditorViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class PostEditorViewController : UIViewController,UITextViewDelegate
{
    var window: UIWindow?
    var ref : DatabaseReference!
    var postId:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.postTextView.delegate = self
        if postId != ""{
            _ = self.ref.child("posts").queryOrdered(byChild: "postId").queryEqual(toValue: self.postId).observe(.childAdded, with: { (snapshot) in
                guard snapshot.exists() else{
                    print ("There is no Rooooooooooooow")
                    return
                }
                let post = snapshot.value as? NSDictionary
                self.postTextView.text = post?["message"] as? String
            })
        }
        
    }


    @IBOutlet weak var postTextView: UITextView!{
        didSet{
            postTextView.layer.borderWidth = 1.0
            postTextView.layer.borderColor = UIColor.purple.cgColor
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.postTextView.resignFirstResponder()
        return true
    }
    
    @IBAction func savePost(_ sender: Any) {
        let userPost = self.postTextView.text
        self.ref = Database.database().reference()
        
        if self.postId != "" {
            let postRef = self.ref.child("posts").child(self.postId)
            let post = ["message":userPost]
            postRef.updateChildValues(post)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTB")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
            
        else if userPost != nil {
            let postId = self.ref.child("posts").childByAutoId().key
            let userId = Auth.auth().currentUser?.uid
            self.ref.child("posts").child(postId).child("userId").setValue(userId)
            self.ref.child("posts").child(postId).child("message").setValue(userPost)
            self.ref.child("posts").child(postId).child("postId").setValue(postId)
            self.ref.child("posts").child(postId).child("isPublic").setValue(true)
            self.ref.child("posts").child(postId).child("Date").setValue(ServerValue.timestamp())
            
            let notificationId = self.ref.child("notifications").childByAutoId().key
            self.ref.child("notifications").child(notificationId).child("userId").setValue(userId)
            self.ref.child("notifications").child(notificationId).child("postId").setValue(postId)
            self.ref.child("notifications").child(notificationId).child("status").setValue("Add a new Post")
            
            
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
}
