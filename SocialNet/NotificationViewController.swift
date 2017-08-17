//
//  NotificationViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//


import UIKit
import Firebase

class NotificationViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var ref: DatabaseReference!
    struct cellData{
        let cell:Int!
        let text:String!
    }
    
    var arrayOfCellDate = [cellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellDate = [cellData(cell:1,text:"Julian Commented on Your Post"),
        cellData(cell:1,text:"Julian Commented on Your Post"),
        cellData(cell:1,text:"Julian Commented on Your Post"),
        cellData(cell:1,text:"Julian Commented on Your Post"),
        cellData(cell:1,text:"Julian Commented on Your Post"),
            cellData(cell:1,text:"Julian Commented on Your Post"),
            cellData(cell:1,text:"Julian Commented on Your Post"),
            cellData(cell:1,text:"Julian Commented on Your Post"),
            cellData(cell:1,text:"Julian Commented on Your Post")]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellDate.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellDate[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("NotificationTabelViewCell1", owner: self, options: nil)?.first as! NotificationTabelViewCell1
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                            let username = auth.currentUser?.displayName
                            //cell.userNameNotificationLabel.text = (username)!
                            //cell.userCommentNotificationLabel.text = "Commented on your Post"
                           let photoURL = auth.currentUser?.photoURL
                        let data = NSData(contentsOf: photoURL!)
                   cell.userProfileNotificationViewImage.image = UIImage(data: data! as Data)
                    
                    
                    
                    
                    let userPostQuery = self.ref.child("notifications").observe(.childAdded, with: { (snapshot) in
                        
                        let post = snapshot.value as? String
                        if let actualPost = post {
                            cell.userCommentNotificationLabel.text = actualPost
                            cell.userNameNotificationLabel.text = actualPost
                           
                        }
                        cell.reloadInputViews()
                    })
                    
                    
                    
                    
                    
                    
                    
                    
                    
                }
            }
            return cell
        }
        else if arrayOfCellDate[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("NotificationTabelViewCell1", owner: self, options: nil)?.first as! NotificationTabelViewCell1
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let username = auth.currentUser?.displayName
                    //cell.userNameNotificationLabel.text = (username)!
                    //cell.userCommentNotificationLabel.text = "Commented on your Post"
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userProfileNotificationViewImage.image = UIImage(data: data! as Data)
                }
                
                
                
                
                
                let userPostQuery = self.ref.child("notifications").observe(.childAdded, with: { (snapshot) in
                    
                    let post = snapshot.value as? String
                    if let actualPost = post {
                        cell.userCommentNotificationLabel.text = actualPost
                        cell.userNameNotificationLabel.text = actualPost
                        
                    }
                    cell.reloadInputViews()
                })

                
                
                
                
                
                
                
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }

}


