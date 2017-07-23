//
//  HomeViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    struct cellData{
        let cell:Int!
        let text:String!
    }
    
    var arrayOfCellDate = [cellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellDate = [cellData(cell:1,text:"Julian Commented on Your Post"),
                           cellData(cell:2,text:"Julian Commented on Your Post"),
                           cellData(cell:3,text:"Julian Commented on Your Post"),
                           cellData(cell:4,text:"Julian Commented on Your Post"),
                           cellData(cell:5,text:"Julian Commented on Your Post"),
                           ]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellDate.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellDate[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellSlider", owner: self, options: nil)?.first as! HomeTableViewCellSlider
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userHomeSliderViewImage.image = UIImage(data: data! as Data)
                    //cell.addSubview(cell.userHomeSliderViewImage)
                }
            }
            return cell
        }
        else if arrayOfCellDate[indexPath.row].cell == 2 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellAddPost", owner: self, options: nil)?.first as! HomeTableViewCellAddPost
            return cell
        }
        else if arrayOfCellDate[indexPath.row].cell == 3 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellPost", owner: self, options: nil)?.first as! HomeTableViewCellPost
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userProfileViewImage.image = UIImage(data: data! as Data)
                    cell.userCommentPostViewImage.image = UIImage(data: data! as Data)
                    cell.userPostLabel.text = "Hello i am here , Hello i am here , Hello i am here"
                    cell.userCommentLabel.text = "Gooddddddddd"
                    cell.userPostLabel.numberOfLines = 0
                    cell.userCommentLabel.numberOfLines = 0
                }
            }
            return cell
        }
        else if arrayOfCellDate[indexPath.row].cell == 4 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellPost", owner: self, options: nil)?.first as! HomeTableViewCellPost
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userProfileViewImage.image = UIImage(data: data! as Data)
                    cell.userCommentPostViewImage.image = UIImage(data: data! as Data)
                    cell.userPostLabel.text = "I want to go :-( , I want to go :-( , I want to go :-("
                    cell.userCommentLabel.text = "Nooooooooooooooo"
                    cell.userPostLabel.numberOfLines = 0
                    cell.userCommentLabel.numberOfLines = 0
                }
            }
            return cell
        }
        else if arrayOfCellDate[indexPath.row].cell == 5 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellPost", owner: self, options: nil)?.first as! HomeTableViewCellPost
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userProfileViewImage.image = UIImage(data: data! as Data)
                    cell.userCommentPostViewImage.image = UIImage(data: data! as Data)
                    cell.userPostLabel.text = "I go to School today , I go to School today ,I go to School today , I go to School today"
                    cell.userCommentLabel.text = "Ahhhhhhhhhh"
                    cell.userPostLabel.numberOfLines = 0
                    cell.userCommentLabel.numberOfLines = 0
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
                if arrayOfCellDate[indexPath.row].cell == 1 {
                    return 220
                }
                else if arrayOfCellDate[indexPath.row].cell == 2 {
                    return 60
                }
                else if arrayOfCellDate[indexPath.row].cell == 3 {
                    return 240
                }
        return 240
    }
    
}
