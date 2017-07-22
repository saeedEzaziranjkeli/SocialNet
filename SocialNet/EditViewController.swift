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
        self.usernameTextbox.delegate = self
        self.emailTextbox.delegate = self
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                let username = auth.currentUser?.displayName
                let email = auth.currentUser?.email
                self.usernameTextbox.text = username
                self.emailTextbox.text = email
            }
            else{
                print("User must Signin")
            }
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextbox.resignFirstResponder()
        self.usernameTextbox.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButton(_ sender: Any) {
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
