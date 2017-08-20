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
    
    var userId:String!
    @IBOutlet var NotificationsTableView: UITableView!
    var commentList = [NSDictionary?]()
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
                    self.userId = Auth.auth().currentUser?.uid
                _ = self.ref.child("notifications").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.childAdded, with: { (snapshot) in
                    self.commentList.append(snapshot.value as? NSDictionary)
                    self.NotificationsTableView.insertRows(at: [IndexPath(row:self.commentList.count-1,section:0)], with: .automatic)
                })

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.borderColor = UIColor.white.cgColor
        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height)!/2
        cell.imageView?.clipsToBounds = true
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                        let username = auth.currentUser?.displayName
                        let photoURL = auth.currentUser?.photoURL
                        let data = NSData(contentsOf: photoURL!)
                        cell.imageView?.image = UIImage(data: data! as Data)
                   
                    _ = self.ref.child("notifications").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.childAdded, with: { (snapshot) in
                        guard snapshot.exists() else{
                            print ("There is no Rooooooooooooow")
                            return
                        }
                        cell.textLabel?.text = self.commentList[indexPath.row]?["status"] as! String?
                        cell.detailTextLabel?.text = username
                    })
                }
            }
            return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }

}
