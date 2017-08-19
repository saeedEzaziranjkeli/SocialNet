import UIKit
import Firebase
import FirebaseStorage
class HomeViewController:UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var ref: DatabaseReference!
    var countOfPostCell = 0{
        didSet{
            tableView.reloadData()
        }
    }

    var postsList = [NSDictionary?](){
        didSet{
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

                self.ref = Database.database().reference()
        Auth.auth().addStateDidChangeListener{(auth,user) in
            if user != nil{
                self.userId = auth.currentUser?.uid
                _ = self.ref.child("posts").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.value, with: { (snapshot) in
                    self.countOfPostCell = Int(snapshot.childrenCount)
                    let post = snapshot.value as? NSDictionary
                    for (_,item) in post!{
                        self.postsList.append(item as? NSDictionary)
                    }
                })
            }
        }
}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2  + self.countOfPostCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellSliderImage") as! HomeTableViewCellSlider
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
        else if indexPath.row == 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeViewControllerButton") as! HomeTableViewCellAddPost
            return cell
        }
        else if indexPath.row >= 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewControllerPost") as! HomeTableViewCellPost
            
            let _indexDatabase = indexPath.row - 2
            print("66666666666",_indexDatabase)
            //print("00000000000",self.postsList[_indexDatabase] ?? "6565656565")
            //BEGIN

            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil{
                    let photoURL = auth.currentUser?.photoURL
                    let data = NSData(contentsOf: photoURL!)
                    self.userId = auth.currentUser?.uid
                    cell.userProfileViewImage.image = UIImage(data: data! as Data)
                    //cell.userCommentPostViewImage.image = UIImage(data: data! as Data)
//                    _ = self.ref.child("posts").queryOrdered(byChild: "userId").queryEqual(toValue: self.userId).observe(.childAdded, with: { (snapshot) in
////                        
////                        guard snapshot.exists() else{
////                            print ("There is no Rooooooooooooow")
////                            return
////                        }
////                        
//                       let post = snapshot.value as? NSDictionary
////                        print("5555555555555555555",post?["message"] as! String?)
////                        
//                    })
//                    //cell.userCommentLabel.text = "Gooddddddddd"
//                    cell.userPostLabel.numberOfLines = 0
//                    //cell.userCommentLabel.numberOfLines = 0
//                    
       }
//                    
                    cell.userPostLabel.text = self.postsList[_indexDatabase]?["message"] as! String?

            }
            
            //END
            return cell
        }

        //tableView.beginUpdates()
        //tableView.insertRows(at:[IndexPaths], with: .top)
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 220
        }
     return UITableViewAutomaticDimension
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row < 2 {
            return false
        }
        return true

    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, _indexPath) in
            self.performSegue(withIdentifier: "editPostSegue", sender: nil)
        }
        let comment = UITableViewRowAction(style: .normal, title: "+Com.") { (action, _indexPath) in
            self.performSegue(withIdentifier: "addCommentSegue", sender: nil)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, _indexPath) in
            
        }
        edit.backgroundColor = .blue
        comment.backgroundColor = .yellow
    
        return [edit,delete,comment]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPostSegue"{
            let peVC = segue.destination as! PostEditorViewController
//            peVC.postTextView.text = "Baghali"
        }
        else if segue.identifier == "addCommentSegue"{
            let addComment = segue.destination as! CommentViewController
            //            peVC.postTextView.text = "Baghali"
        }
    }
}
