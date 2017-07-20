//
//  ViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 17/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController, GIDSignInUIDelegate {
@IBOutlet weak var signInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SignInButton(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }

}

