import UIKit
import Firebase
import FirebaseStorage
class HomeViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var ref: DatabaseReference!
    struct cellData{
        let cell:Int!
        let text:String!
    }
    
    var arrayOfCellDate = [cellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCellDate = [cellData(cell:1,text:"Julian Commented on Your Post"),
                           cellData(cell:2,text:"Julian Commented on Your Post"),
                           cellData(cell:3,text:"Julian Commented on Your Post")
        ]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellDate.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.ref = Database.database().reference()
        if arrayOfCellDate[indexPath.row].cell == 1 {
            let cell = Bundle.main.loadNibNamed("HomeTableViewCellSlider", owner: self, options: nil)?.first as! HomeTableViewCellSlider
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    self.userId = auth.currentUser?.uid
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    cell.userHomeSliderViewImage.image = UIImage(data: data! as Data)
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
                    _ = self.ref.child("posts").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.childAdded, with: { (snapshot) in
                        
                        guard snapshot.exists() else{
                            print ("There is no Rooooooooooooow")
                            return
                        }
                        
                        let post = snapshot.value as? NSDictionary
                        cell.userPostLabel.text = post?["message"] as! String?
                        print("5555555555555555555",post?["message"] as! String?)
                        cell.reloadInputViews()
                        
                    })
                    cell.userCommentLabel.text = "Gooddddddddd"
                    cell.userPostLabel.numberOfLines = 0
                    cell.userCommentLabel.numberOfLines = 0
                }
            }
            
            return cell
        }

        //tableView.beginUpdates()
        //tableView.insertRows(at:[IndexPaths], with: .top)
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
    
    //var storage = Storage.storage(url:"gs://socialnet-91a2c.appspot.com/").reference()
    let storageRef = Storage.storage().reference()
    var userId:String!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image  = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! HomeTableViewCellSlider
            cell.userHomeSliderViewImage.image = image;
            self.dismiss(animated: true, completion: nil)
            let imagesRef = storageRef.child("images/"+self.userId + "/Profile")
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
