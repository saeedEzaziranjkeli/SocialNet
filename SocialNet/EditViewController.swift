//
//  EditViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 22/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
class EditViewController:UIViewController,UITextFieldDelegate{
    var window:UIWindow?
    @IBOutlet weak var usernameTextbox: UITextField!
    
    @IBOutlet weak var emailTextbox: UITextField!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.usernameTextbox.delegate = self
        self.emailTextbox.delegate = self
                let userId = Auth.auth().currentUser?.uid
                _ = self.ref.child("user_profiles").child(userId!).observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                   let value = snapshot.value as? NSDictionary
                    self.usernameTextbox.text = value?["username"] as? String
                    self.emailTextbox.text = value?["email"] as? String
                    
                  
                })
    

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextbox.resignFirstResponder()
        self.usernameTextbox.resignFirstResponder()
        return true
    }
    
    
    @IBAction func saveEditButton(_ sender: Any) {
        let username = self.usernameTextbox.text
        let email = self.emailTextbox.text
        self.ref = Database.database().reference()
        if username != nil && email != nil{
            self.ref.child("user_profiles").child((Auth.auth().currentUser?.uid)!).updateChildValues(["username":username ?? " "])
            self.ref.child("user_profiles").child((Auth.auth().currentUser?.uid)!).updateChildValues(["email":email ?? " "])
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }
   
    
    
}
