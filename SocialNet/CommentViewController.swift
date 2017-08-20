
import UIKit
import Firebase

class CommentViewController : UIViewController,UITextViewDelegate
{
    var window: UIWindow?
    var ref : DatabaseReference!
    var postId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentTextView.delegate = self
    }
    @IBOutlet weak var commentTextView: UITextView!{
        didSet{
            self.commentTextView.layer.borderWidth = 2.0
            self.commentTextView.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBAction func btnSaveComment(_ sender: Any) {
        let userComment = self.commentTextView.text
        self.ref = Database.database().reference()
        if userComment != nil {
            let commentId = self.ref.child("comments").childByAutoId().key
            let userId = Auth.auth().currentUser?.uid
            self.ref.child("comments").child(commentId).child("userId").setValue(userId)
            self.ref.child("comments").child(commentId).child("message").setValue(userComment)
            self.ref.child("comments").child(commentId).child("postId").setValue(postId)
            self.ref.child("comments").child(commentId).child("isPublic").setValue(true)
        self.ref.child("comments").child(commentId).child("Date").setValue(ServerValue.timestamp())
            let notificationId = self.ref.child("notifications").childByAutoId().key
            self.ref.child("notifications").child(notificationId).child("userId").setValue(userId)
            self.ref.child("notifications").child(notificationId).child("postId").setValue(postId)
            self.ref.child("notifications").child(notificationId).child("status").setValue("Add a new Comment on your Post")
            
            
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTB")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.commentTextView.resignFirstResponder()
        return true
    }
    
    
}
