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
    @IBOutlet weak var userConfirmPasswordText: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmailText.delegate = self;
        self.userPasswordtext.delegate = self;
        self.userConfirmPasswordText.delegate = self;

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userEmailText.resignFirstResponder()
        userPasswordtext.resignFirstResponder()
        userConfirmPasswordText.resignFirstResponder()
        return true
    }

    @IBAction func registerUser(_ sender: Any) {
        let userEmail = userEmailText?.text
        let userPassword = userPasswordtext?.text
        let userConfirmPassword = userConfirmPasswordText?.text
        if userEmail == "" || userPassword == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else if userPassword != userConfirmPassword{
            let alertController = UIAlertController(title: "Error", message: "Password is not Match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
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
                            userRefrence.child("name").setValue(userEmail)
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
    
}
