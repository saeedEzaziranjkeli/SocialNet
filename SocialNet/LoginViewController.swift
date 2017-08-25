//
//  LoginViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 25/08/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController:UIViewController,UITextFieldDelegate{
    var window: UIWindow?
    var ref: DatabaseReference!
    @IBOutlet weak var userPasswordtext: UITextField!
    @IBOutlet weak var userEmailText: UITextField!
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
    
    @IBAction func btnLogin(_ sender: Any) {
        let userEmail = userEmailText?.text
        let userPassword = userPasswordtext?.text
        if userEmail == "" || userPassword == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().signIn(withEmail: self.userEmailText.text!, password: self.userPasswordtext.text!) { (user, error) in
                if error == nil {
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
