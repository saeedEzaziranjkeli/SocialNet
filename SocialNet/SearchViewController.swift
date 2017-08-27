
import UIKit
import Firebase

class SearchViewController : UITableViewController,UISearchResultsUpdating
{
    var window: UIWindow?
    var ref : DatabaseReference!
    var userId : String = ""

    @IBOutlet var searchFirendsTableView: UITableView!
    var users = [NSDictionary?]()
    var filteresUsers = [NSDictionary?]()
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
         self.ref = Database.database().reference()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        _ = self.ref.child("user_profiles").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
            
            guard snapshot.exists() else{
                print ("There is no Rooooooooooooow")
                return
            }
            
            self.users.append(snapshot.value as? NSDictionary)
            self.searchFirendsTableView.insertRows(at: [IndexPath(row:self.users.count-1,section:0)], with: .automatic)
            
        })

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return self.filteresUsers.count
        }
        return self.users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user : NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            user = self.filteresUsers[indexPath.row]
        }
        else{
            user = self.users[indexPath.row]
        }
        cell.textLabel?.text = user?["name"] as? String
        cell.detailTextLabel?.text = user?["email"] as? String
        
        return cell
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: searchController.searchBar.text!)
    }
    
    @IBAction func dismissSearchTableViewController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func filterContent(searchText:String){
        self.filteresUsers = self.users.filter{user in
            let username = user!["name"] as? String
            return (username?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let user = self.users[indexPath.row]
            self.userId = user?["userId"] as! String
        }
        if segue.identifier == "showUserPageSegue"{
            if let userVC = segue.destination as? UserViewController{
                userVC.userId = self.userId
            }
        }
    }
    
    
}
