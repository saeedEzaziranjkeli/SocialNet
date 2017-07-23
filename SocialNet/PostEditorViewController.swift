//
//  PostEditorViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit

class PostEditorViewController : UIViewController,UITextViewDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTextView.delegate = self
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
        postTextView.resignFirstResponder()
        return true
    }
}
