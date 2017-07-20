//
//  RegisterViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 19/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController:UIViewController,UITextFieldDelegate{
    var window: UIWindow?
    var ref: DatabaseReference!
    @IBOutlet weak var userEmailText: UITextField!
    @IBOutlet weak var userPasswordtext: UITextField!
    @IBAction func registerUser(_ sender: Any) {
        let userEmail = userEmailText?.text
        let userPassword = userPasswordtext?.text
        if((userEmail == nil) || (userPassword == nil)){
            print("You Must Fill Data")
        }
        else{
            Auth.auth().createUser(withEmail: userEmail!, password: userPassword!, completion: { (user, error) in
                if error != nil{
                    print("Error")
                }
                else{
                    
                    self.ref = Database.database().reference()
                    
                    self.ref.child("user_profiles").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshot = snapshot.value as? NSDictionary
                        
                        if(snapshot == nil)
                        {
                            let userRefrence = self.ref.child("user_profiles").childByAutoId();
                            userRefrence.child("email").setValue(userEmail)
                            userRefrence.child("password").setValue(userPassword)
                            self.window = UIWindow(frame: UIScreen.main.bounds)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
                            
                            self.window?.rootViewController = initialViewController
                            self.window?.makeKeyAndVisible()
                            print("User Registered")
                        }
                        else{
                            print("Moshkel dare")
                        }

                    
                })
            }
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailText.delegate = self;
        self.userPasswordtext.delegate = self;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailText.resignFirstResponder()
        userPasswordtext.resignFirstResponder()
        return true
    }
    /**
     * Called when the user click on the view (outside the UITextField).
     */
   }
