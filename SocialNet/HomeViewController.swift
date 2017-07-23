//
//  HomeViewController.swift
//  SocialNet
//
//  Created by saeed EzaziRanjKeli on 23/07/17.
//  Copyright © 2017 saeed EzaziRanjKeli. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
class HomeViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var userId:String!
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
                    self.userId = auth.currentUser?.uid
                    let imagesRef = self.storageRef.child("images/"+self.userId + "/HomeImage.jpg")
                    imagesRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        if error == nil{
                            cell.userHomeSliderViewImage.image = UIImage(data: data! as Data)
                        }
                        else{
                            let photoURL = auth.currentUser?.photoURL
                            let data = NSData(contentsOf: photoURL!)
                            cell.userHomeSliderViewImage.image = UIImage(data: data! as Data)
                            print("Moshkel darad")
                        }
                    })

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true)
        case 1:
            performSegue(withIdentifier: "addNewPostSegue", sender: nil)
        default:
            break
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! HomeTableViewCellSlider
            cell.userHomeSliderViewImage.image = image;
            self.dismiss(animated: true, completion: nil)
            let imagesRef = storageRef.child("images/"+self.userId + "/HomeImage.jpg")
            let metaDataObj = StorageMetadata()
            metaDataObj.contentType = "image/jpeg"
            imagesRef.putData(UIImageJPEGRepresentation(image, 0.0)!, metadata: metaDataObj, completion: { (data, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "dare")
                }
                else{
                    print("man okeyam")
                }
                let downloadURL = metaDataObj.downloadURLs
                print(downloadURL)
            })
            
        }
        else{
            print("Image has Problem")
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
