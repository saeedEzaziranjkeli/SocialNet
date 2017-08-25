
import UIKit
import Firebase

class CommentTableViewController : UITableViewController
{
    var window: UIWindow?
    var ref : DatabaseReference!
    var postId:String = ""
    @IBOutlet var CommentTableView: UITableView!
    var comments = [NSDictionary?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.postId != ""{
            self.ref = Database.database().reference()
            _ = self.ref.child("comments").queryOrdered(byChild: "postId").queryEqual(toValue: self.postId).observe(.value, with: { (snapshot) in
                
                guard snapshot.exists() else{
                    print ("There is no Rooooooooooooow")
                    return
                }
                let post = snapshot.value as? NSDictionary
                for (_,item) in post!{
                    self.comments.append(item as? NSDictionary)
                }
                self.tableView.reloadData()
            })

        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user : NSDictionary?
        user = self.comments[indexPath.row]
        cell.textLabel?.text = user?["message"] as? String
        return cell
    }
    var commentId:String = ""
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, _indexPath) in
            self.commentId = (self.comments[(_indexPath.row)]?["commentId"] as? String)!
            self.performSegue(withIdentifier: "editCommentSegue", sender: nil)
        }
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, _indexPath) in
            Auth.auth().addStateDidChangeListener{(auth,user) in
                if user != nil {
                    let commentId = self.comments[(_indexPath.row)]?["commentId"] as? String
                    self.ref.child("comments").child(commentId!).removeValue{error in
                        
                    }
                    self.comments = [NSDictionary]()
                }
            }
            
        }
        edit.backgroundColor = .blue
        return [edit,delete]
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCommentSegue"{
            if let edCV = segue.destination as? CommentViewController{
                edCV.postId = self.postId
                edCV.commentId = self.commentId
            }
        }
        if segue.identifier == "AddCommentSegue"{
            if let edCV = segue.destination as? CommentViewController{
                edCV.postId = self.postId
            }
        }
            
    }

    
}
