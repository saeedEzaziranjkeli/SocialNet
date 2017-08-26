//
//  ViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 17/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
    var window:UIWindow?
@IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let defaultvalue : [String:Any] = [
            "Email" : "",
            "Password": ""
        ]
        UserDefaults.standard.register(defaults: defaultvalue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userDefaults = UserDefaults.standard
        let email = userDefaults.string(forKey: "email_preference")
        let password = userDefaults.string(forKey: "password_preference")
        print("555555555",email,"55555555",password)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func unwindCancel(segue:UIStoryboardSegue) {
        
    }

}

