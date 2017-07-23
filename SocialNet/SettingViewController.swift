//
//  SettingController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 22/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var userId:String!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var userProfileImage: UIImageView!
    
    private let normalCellID = "SettingsNormalCell"
    private let profileDetailCellID = "SettingsProfileDetailCell"
    
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return 2
        }
        else if section == 2{
            return 1
        }
        return -1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: profileDetailCellID) as! ProfilDetailCell
           
                    cell.userProfileImageView.layer.borderWidth = 1
            cell.userProfileImageView.layer.masksToBounds = true
            cell.userProfileImageView.layer.borderColor = UIColor.white.cgColor
                    cell.userProfileImageView.layer.cornerRadius = cell.userProfileImageView.bounds.size.height/2
                    Auth.auth().addStateDidChangeListener{(auth,user) in
                        if user != nil{
                            let username = auth.currentUser?.displayName
                            cell.usernameLabel.text = username
//                            let photoURL = auth.currentUser?.photoURL
//                            let data = NSData(contentsOf: photoURL!)
//                            cell.userProfileImageView.image = UIImage(data: data! as Data)
                            self.userId = auth.currentUser?.uid
                            let imagesRef = self.storageRef.child("images/"+self.userId + "/ProfileImage.jpg")
                            imagesRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                                if error == nil{
                                    cell.userProfileImageView.image = UIImage(data: data! as Data)
                                }
                                else{
                                    let photoURL = auth.currentUser?.photoURL
                                    let data = NSData(contentsOf: photoURL!)
                                    cell.userProfileImageView.image = UIImage(data: data! as Data)
                                    print("Moshkel darad")
                                }
                            })
                        }
                        else{
                            print("User must Signin")
                        }
                    }
            
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: normalCellID)

            if indexPath.item == 0 {
                cell?.textLabel?.text = "Edit Your Account"
                return cell!
            }else if indexPath.item == 1 {
                cell?.textLabel?.text = "Change Your Picture"
                return cell!
            }
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: normalCellID)

            cell?.textLabel?.text = "Log Out"
            return cell!
        }
        
        return UITableViewCell()
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 1 && indexPath.item == 0 {
            performSegue(withIdentifier: "segueEditorViewController", sender: nil)
        }
    }
    
     
    }


class ProfilDetailCell:UITableViewCell{

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    

}



