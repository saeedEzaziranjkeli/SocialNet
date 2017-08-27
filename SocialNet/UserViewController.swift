//
//  UserViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 27/08/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//
import UIKit
import Firebase
import FirebaseStorage
class UserViewController:UITableViewController{
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var userId:String = ""
    var postsList = [NSDictionary?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                self.postsList = [NSDictionary]()
                _ = self.ref.child("posts").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.value, with: { (snapshot) in
                    guard snapshot.exists() else {
                        return
                    }
                    self.postsList = [NSDictionary]()
                    let post = snapshot.value as? NSDictionary
                    for (_,item) in post!{
                        self.postsList.append(item as? NSDictionary)
                    }
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  + self.postsList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellSliderImage") as! HomeTableViewCellSlider
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let imagesRef = self.storageRef.child("images/"+self.userId + "/Profile.jpg")
                    imagesRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if error == nil{
                            cell.userHomeSliderViewImage.image = UIImage(data: data! as Data)
                        }
                        else{
                            cell.userHomeSliderViewImage.image = UIImage(named:"DefaultProfile")
                        }
                    })
                }
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewControllerPost") as! HomeTableViewCellPost
            let _indexDatabase = indexPath.row - 1
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil {
                    let imagesRef = self.storageRef.child("images/"+self.userId + "/ProfileImage.jpg")
                    imagesRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if error == nil{
                            cell.userProfileViewImage.image = UIImage(data: data! as Data)
                        }
                        else{
                            if let photoURL = auth.currentUser?.photoURL{
                                let data = NSData(contentsOf: photoURL)
                                cell.userProfileViewImage.image = UIImage(data: data! as Data)
                            }
                            else{
                                cell.userProfileViewImage.image = UIImage(named:"DefaultProfile")
                            }
                        }
                    })
                    cell.userPostLabel.text = self.postsList[_indexDatabase]?["message"] as! String?
                    cell.userPostLabel.numberOfLines = 0
                }
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 220
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < 1 {
            return false
        }
        return true
        
    }
    var postId:String!
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let comment = UITableViewRowAction(style: .normal, title: "+Com.") { (action, _indexPath) in
            self.postId = self.postsList[(_indexPath.row-1)]?["postId"] as? String
            self.performSegue(withIdentifier: "userCommentTableSegue", sender: nil)
        }
        comment.backgroundColor = .blue
        return [comment]
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userCommentTableSegue"{
            if let cmTVC = segue.destination as? UserCommentTableViewController{
                cmTVC.postId = self.postId
                //cmTVC.userId = self.userId
            }
        }
    }
}
