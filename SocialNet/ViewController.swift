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
        
//        Auth.auth().addStateDidChangeListener{(auth,user) in
//            
//            if Auth.auth().currentUser != nil{
//                print("User SignedIn")
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
//                
//                self.window?.rootViewController = initialViewController
//                self.window?.makeKeyAndVisible()
//
//            }
//            else{
//                print("User must Signin")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

}

