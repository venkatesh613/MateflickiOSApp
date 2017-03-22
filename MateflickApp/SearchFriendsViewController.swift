//
//  SearchFriendsViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 19/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating{
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFriends: [String] = []
    var allFriends = [AnyObject]()
    var str = String()
    var names: [String] = []
    var image: [String] = []
    
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //lab = UserDefaults.standard.object(forKey: "firstName") as! String
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // self.resultSearchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.becomeFirstResponder()
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Filter"
        
        //self.searchView.addSubview(self.searchController.searchBar)
        //searchController.searchBar.backgroundColor = UIColor .red
        searchController.searchBar.tintColor = UIColor .red
        //self.searchController.searchBar.frame = CGRect(x: 0, y: 10, width: 400, height: 0)
        //self.searchController.searchBar.frame.size.width = self.view.frame.size.width
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //searchController.searchBar.showsCancelButton = false
        //searchController.isActive = false
        //self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchController.isActive {
            return filteredFriends.count
        }else{
            return names.count
        }
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! SearchFriendsTableViewCell
        
        if self.searchController.isActive == true  {
            
            cell.searchFriendName.text = filteredFriends[indexPath.row]
            cell.searchFriendImageBtn.layer.cornerRadius = cell.searchFriendImageBtn.frame.size.width / 2
            cell.searchFriendImageBtn.clipsToBounds = true
               if  let url = NSURL(string: self.image[indexPath.row]) {
               if let data = NSData(contentsOf: url as URL){
                cell.searchFriendImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
           }
        }

        } else {
            //cell.textLabel?.text = names[indexPath.row]
            //cell.imageView?.image = UIImage (named: "profile")
            
        }
        
        return cell
    }
    public func updateSearchResults(for searchController: UISearchController) {
        
        //self.userDataFetch()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchFriendsViewController.userDataFetch), object: nil)
        self.perform(#selector(SearchFriendsViewController.userDataFetch), with: nil, afterDelay: 1.0)
        self.filteredFriends.removeAll()
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (self.names as NSArray).filtered(using: searchPredicate)
        filteredFriends = array as! [String]
        print("Filltered",filteredFriends)
        self.names.removeAll()
        //self.image.removeAll()
        self.tableView.reloadData()
        
        
    }
    
    //    @available(iOS 2.0, *)
    //     public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //
    //        let PVC = self.storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
    //        self.present(PVC, animated: true, completion: nil)
    //    }
    func userDataFetch() {
        
        let searchText = searchController.searchBar.text
        let editSearchText = searchText?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        let url = URL(string: "http://api.mateflick.host/Search/Default.aspx?firstName="+editSearchText!+"&accountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    
                    //self.allFriends = json["SearchUserList"] as! [AnyObject]
                    //let demoDict = self.allFriends[0] as! [String: AnyObject]
                    
                    if let arrJSON = json["SearchUserList"] {
                        for index in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let firstName = index["firstName"] as! String
                            let profilePic = index["profilePic"] as! String
                            
                            self.names.append(firstName)
                            self.image.append(profilePic)
                        }
                    }
                    print("names",self.names)
                    print("image",self.image)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        //self.tableView.reloadData()
                    }
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
