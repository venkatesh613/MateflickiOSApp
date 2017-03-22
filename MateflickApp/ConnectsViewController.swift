//
//  ConnectsViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 08/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import AFNetworking
import Firebase
import CoreData
struct Image {
    static var img = String()
    static var hide = String()
    static var mateFlickID = String()
    static var sessionName = String()
    static var groupIDsArray = [String]()
    static var selectedID = String()
    
}

class ConnectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SINCallClientDelegate{
    
    
    var activityView = UIActivityIndicatorView()
    var nameField = UITextField()
    var app = AppDelegate()
    var coreImageData = NSData()
    var refreshController = UIRefreshControl()
    //firebase properties
    
    var senderDisplayName = String()
    var newChannelTextField: UITextField?
    var session: String?
    private var channelRefHandle: FIRDatabaseHandle?
    //private var channels: [Channel] = []
    var names = [Channel]()
    var nam = [String]()
    var profilePic = [String]()
    var friendAccountId = [String]()
    
    private lazy var channelRef: FIRDatabaseReference = FIRDatabase.database().reference()
    //................
    
    @IBOutlet weak var createGroupBtn: UIButton!
    @IBOutlet weak var friendslabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var connectslabel: UILabel!
    @IBOutlet weak var callsLabel: UILabel!
    var groupIDsArr = [String]()
    var groupID = Int()
    var groupIDStr = String()
    
    
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var groupTableView: UITableView!
    @IBOutlet weak var connectsTableView: UITableView!
    @IBOutlet weak var callsTableView: UITableView!
    
    //Friends
    var friendsListArray = [String]()
    var friendAccountIdArray = [String]()
    var friendFirstNameArray = [String]()
    var friendProfilePicArray = [String]()
    var sessionNameDict = [String: Any]()
    var sessionName = String()
    //Group
    var groupListarray = [String]()
    var groupIdArray = [Int]()
    var groupNameArray = [String]()
    var groupPicArray = [String]()
    
    //Connects
    var connectsSenderIdArray = [AnyObject]()
    var connectsNameArray = [String]()
    var connectsProfilePicArray = [AnyObject]()
    var connectsSessionNameArray = [String]()
    var connectsTypeIdArray = [String]()
    var connectsTypeArray = [String]()
    //Calls
    var callautoId = [Int]()
    var calltoAccountId = [String]()
    var callfirstname = [String]()
    var callprofilePic = [String]()
    var callcallType = [String]()
    var calldatetime = [String]()
    var callstatus = [String]()
    var callduration = [String]()
    
    
    
    var str : String!
    //var app = AppDelegate()
    //COREDATA
    var friendFirstNameCoreArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFriendsData()
        getGroupData()
        getConnectsData()
        getCallsData()
        
        self.senderDisplayName = signInStruct.UName
        //print("senderDisplayName",self.senderDisplayName)
        
        //app = UIApplication.shared().delegate as! AppDelegate
        
        
        
        self.friendsTableView.delegate = self
        self.friendsTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.connectsTableView.delegate = self
        self.connectsTableView.dataSource = self
        self.groupTableView.delegate = self
        self.groupTableView.dataSource = self
        self.callsTableView.delegate = self
        self.callsTableView.dataSource = self
        
        self.friendslabel.isHidden = false
        self.groupLabel.isHidden = true
        self.connectslabel.isHidden = true
        self.callsLabel.isHidden = true
        
        self.friendsTableView.isHidden = false
        self.groupTableView.isHidden = true
        self.connectsTableView.isHidden = true
        self.callsTableView.isHidden = true
        
        self.createGroupBtn.isHidden = true
        
        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        self.activityView.tintColor = UIColor .red
        self.activityView.backgroundColor = UIColor .red
        self.activityView.center = CGPoint(x:UIScreen.main.bounds.size.width / 2, y:UIScreen.main.bounds.size.height / 2)
        
        self.app = UIApplication.shared.delegate as! AppDelegate
        app.window.addSubview(self.activityView)
        refreshController.addTarget(self, action: #selector(getGroupData), for:UIControlEvents.valueChanged)
        self.groupTableView.addSubview(refreshController)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        
        //coreData()
        
        
        //        self.friendsTableView.reloadData()
        //        self.connectsTableView.reloadData()
        //        self.groupTableView.reloadData()
    }
    
    //COREDATA...........
    
    //func coreData() {
    //
    //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //        let context = appDelegate.persistentContainer.viewContext
    //
    //        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Friends", into: context)
    //        if self.friendProfilePicArray.count>0 && self.friendFirstNameArray.count>0 {
    //
    //        let data = NSKeyedArchiver.archivedData(withRootObject: "\(self.friendProfilePicArray)")
    //            newUser.setValue("\(self.friendFirstNameArray)", forKey: "friendName")
    //        newUser.setValue(data, forKey: "friendProfilePic")
    //        }
    //        do {
    //            try
    //                context.save()
    //            print("SAVED SUCCESSFULLY")
    //        }
    //        catch {
    //            print("Error saving Core Data")
    //        }
    //
    //        //Fetch
    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friends")
    //        request.returnsObjectsAsFaults = false
    //
    //        do {
    //            let results = try context.fetch(request)
    //            print("results",results)
    //
    //            if results.count > 0 {
    //                for result in results as! [NSManagedObject] {
    //
    ////                    let data = result.value(forKey: "friendProfilePic") as! NSData
    ////                    let unarchiveObject = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
    ////                    let arrayObject = unarchiveObject as! String
    ////                    self.friendProfilePicArray = [arrayObject]
    //
    //                if let userName = result.value(forKey: "friendName") as? String {
    //                       self.friendFirstNameCoreArray.append(userName)
    //                        print("Username =", self.friendFirstNameCoreArray)
    //
    //                    }
    //                            if let userImage = result.value(forKey: "friendProfilePic") as? NSData{
    //                                print("UserImage =", userImage)
    //                            }
    //
    //
    //
    //
    //                }
    //
    //
    //            }
    //
    //
    //        } catch  {
    //            print("Error loading data")
    //        }
    //
    //    }
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel {
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }
    
    @IBAction func createGroupActionBtn(_ sender: AnyObject) {
        
        //        let GVC = self.storyboard?.instantiateViewController(withIdentifier: "group") as! GroupCreateViewController
        //        self.navigationController?.pushViewController(GVC, animated: true)
    }
    
    @IBAction func friendsActionBtn(_ sender: AnyObject) {
        
        self.createGroupBtn.isHidden = true
        self.friendslabel.isHidden = false
        self.groupLabel.isHidden = true
        self.connectslabel.isHidden = true
        self.callsLabel.isHidden = true
        //TableView
        self.friendsTableView.isHidden = false
        self.groupTableView.isHidden = true
        self.connectsTableView.isHidden = true
        self.callsTableView.isHidden = true
        
    }
    
    @IBAction func groupActionBtn(_ sender: AnyObject) {
        
        self.createGroupBtn.isHidden = false
        self.friendslabel.isHidden = true
        self.groupLabel.isHidden = false
        self.connectslabel.isHidden = true
        self.callsLabel.isHidden = true
        //TableView
        self.friendsTableView.isHidden = true
        self.groupTableView.isHidden = false
        self.connectsTableView.isHidden = true
        self.callsTableView.isHidden = true
        
    }
    
    @IBAction func connectsActionBtn(_ sender: AnyObject) {
        
        self.createGroupBtn.isHidden = true
        self.friendslabel.isHidden = true
        self.groupLabel.isHidden = true
        self.connectslabel.isHidden = false
        self.callsLabel.isHidden = true
        //TableView
        self.friendsTableView.isHidden = true
        self.groupTableView.isHidden = true
        self.connectsTableView.isHidden = false
        self.callsTableView.isHidden = true
        
    }
    
    @IBAction func callsActionBtn(_ sender: AnyObject) {
        
        self.createGroupBtn.isHidden = true
        self.friendslabel.isHidden = true
        self.groupLabel.isHidden = true
        self.connectslabel.isHidden = true
        self.callsLabel.isHidden = false
        //TableView
        self.friendsTableView.isHidden = true
        self.groupTableView.isHidden = true
        self.connectsTableView.isHidden = true
        self.callsTableView.isHidden = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.friendsTableView
        {
            return 1
        }else if tableView == self.groupTableView{
            return 1
        }else if tableView == self.connectsTableView{
            return 1
        }else
        {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.friendsTableView {
            return 50
        }else if tableView == self.groupTableView {
            return 50
        }else if tableView == self.connectsTableView {
            return 50
        }else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if tableView == self.friendsTableView {
            return 0.01
        }else if tableView == self.groupTableView {
            return 0.01
        }else if tableView == self.connectsTableView {
            return 0.01
        }else{
            return 0.01
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.friendsTableView
        {
            return self.friendFirstNameArray.count
        }else if tableView == self.groupTableView{
            return self.groupNameArray.count
        }else if tableView == self.connectsTableView{
            return self.connectsSenderIdArray.count
        }else
        {
            return self.callautoId.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.friendsTableView {
            let CellIdentifier = "friends"
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! FriendsTableViewCell
            
            cell.friendsChatBtn.tag = indexPath.row
            cell.friendsChatBtn.addTarget(self,action:#selector(friendsButtonClicked(sender:)), for: .touchUpInside)
            cell.userNameLabel.text! = "\(self.friendFirstNameArray[indexPath.row])"
            //            if  let url = NSURL(string: self.friendProfilePicArray[indexPath.row]) {
            //                if let data = NSData(contentsOf: url as URL){
            //            cell.userImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
            //
            //                }
            //            }
            
            self.friendsTableView.allowsSelection = false
            self.activityView.stopAnimating()
            
            return cell
            
        } else if tableView == self.groupTableView {
            let CellIdentifier = "group"
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! GroupTableViewCell
            
            cell.groupusernamelabel.text! = "\(self.groupNameArray[indexPath.row])"
            cell.groupChatBtn.tag = indexPath.row
            cell.groupUserImageBtn.tag = indexPath.row
            
            cell.groupChatBtn.addTarget(self,action:#selector(groupButtonClicked(sender:)), for: .touchUpInside)
            //            if  let url = NSURL(string: self.groupPicArray[indexPath.row]) {
            //                if let data = NSData(contentsOf: url as URL){
            //                    cell.groupUserImageBtn.image = UIImage(data: data as Data)
            //                }
            //            }
            self.groupTableView.allowsSelection = false
            //self.groupTableView.separatorStyle = UITableViewCellSeparatorStyle.singleLineEtched
            
            return cell
            
        } else if tableView == self.connectsTableView {
            let CellIdentifier: String = "Connects"
            let cell: ConnectsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? ConnectsTableViewCell
            cell?.connectsUserNameLabel?.text = "\(self.connectsNameArray[indexPath.row])"
            //            if ("\(self.connectsProfilePicArray[indexPath.row])" == "<null>") {
            //                cell?.connectsUserImage.image = UIImage(named: "group")
            //            }else{
            //            if  let url = NSURL(string:((self.connectsProfilePicArray[indexPath.row])as AnyObject) as! String)  {
            //                if let data = NSData(contentsOf: url as URL){
            //                    cell?.connectsUserImage.image = UIImage(data: data as Data)
            //                }
            //            }
            //        }
            
            return cell!
            
        }else {
            let CellIdentifier: String = "calls"
            let cell: CallsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? CallsTableViewCell
            cell?.callsUserNameLabel.text = self.callfirstname[indexPath.row]
            if self.callstatus[indexPath.row] == "Missed call"{
                cell?.callsTypeLabel.textColor = UIColor.red
            }else{
                cell?.callsTypeLabel.textColor = UIColor.lightGray
            }
            cell?.callsTypeLabel.text = self.callstatus[indexPath.row]
            cell?.callsTimeLabel.text = self.calldatetime[indexPath.row]
//            if self.callduration[indexPath.row] == "00:00:00" {
//                cell?.durationLabel.text = "Canceled"
//            }else{
//                cell?.durationLabel.text = self.callduration[indexPath.row]
//            }
//            if  let url = NSURL(string: self.callprofilePic[indexPath.row]) {
//                if let data = NSData(contentsOf: url as URL){
//                    cell?.callsUserImageView.image = UIImage(data: data as Data)
//                    
//                }
//            }
            
            self.callsTableView.allowsSelection = false
            self.activityView.stopAnimating()
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == connectsTableView {
            
            //database reference
            self.channelRef.child("\(self.connectsSessionNameArray[indexPath.row])").observe(.value, with: { snapshot in
                
                if snapshot.exists() {
                    
                }else{
                    
                    self.channelRef.child("\(self.connectsSessionNameArray[indexPath.row])")
                    
                }
                
                
            })
            
            if ("\(self.connectsProfilePicArray[indexPath.row])" == "<null>"){
                Image.img = ""
                Image.hide = "0"
            }else{
                Image.img = self.connectsProfilePicArray[indexPath.row] as! String
                Image.hide = "1"
            }
            if ("\(self.connectsTypeArray[indexPath.row])" == "account"){
                Image.groupIDsArray.removeAll()
                Image.groupIDsArray.append(String( describing: UserDefaults.standard.integer(forKey: "id")))
                Image.mateFlickID = "\(self.connectsTypeIdArray[indexPath.row])"
                Image.groupIDsArray.append(Image.mateFlickID)
                Image.selectedID = "\(self.connectsTypeIdArray[indexPath.row])"
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    Image.selectedID = "\(self.connectsTypeIdArray[indexPath.row])"
                    self.groupIDStr = "\(self.connectsTypeIdArray[indexPath.row])"
                    self.groupIDsDataFetch()
                    print("Image.groupIDsArrayconedsfgdbg",Image.groupIDsArray)
                    
                    
                }
            }
            
            
            
            let chann = Channel(id:"\(self.connectsSessionNameArray[indexPath.row])", name: self.connectsNameArray[indexPath.row])
            self.performSegue(withIdentifier: "show", sender: chann)
            
        }
    }
    
    func friendsButtonClicked(sender:UIButton) {
        
        //Chat session
        let Tag = sender.tag
        
        let parameters = ["fromAccountId": String( describing: UserDefaults.standard.integer(forKey: "id")) ,
                          "toAccountId": self.friendAccountIdArray[Tag]] as Dictionary<String, String>
        let url = URL(string: "http://api.mateflick.host/ChatSession/?")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    //print("Responce",json)
                    
                    
                    self.sessionNameDict = json["response"] as! [String: Any]
                    self.sessionName = (self.sessionNameDict["sessionName"] as! String?)!
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        //database reference
                        self.channelRef.child("\(self.sessionName)").observe(.value, with: { snapshot in
                            
                            if snapshot.exists() {
                                
                            }else{
                                
                                self.channelRef.child("\(self.sessionName)")
                                
                            }
                            
                        })
                        Image.img = self.friendProfilePicArray[Tag]
                        Image.hide = "1"
                        Image.sessionName = "\(self.sessionName)"
                        Image.groupIDsArray.removeAll()
                        Image.mateFlickID = self.friendAccountIdArray[Tag]
                        Image.selectedID = self.friendAccountIdArray[Tag]
                        Image.groupIDsArray.append(String( describing: UserDefaults.standard.integer(forKey: "id")))
                        Image.groupIDsArray.append(Image.mateFlickID)
                        print("fffffImage.groupIDsArray",Image.groupIDsArray)
                        let chann = Channel(id: "\(self.sessionName)", name: self.friendFirstNameArray[Tag])
                        self.performSegue(withIdentifier: "show", sender: chann)
                        
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        
    }
    
    func groupButtonClicked(sender:UIButton) {
        
        //Group Chat session
        let Tag = sender.tag
        
        
        self.groupIDStr = "\(self.groupIdArray[Tag])"
        self.groupIDsDataFetch()
        
        
        //database reference
        self.channelRef.child("\(self.groupIdArray[Tag])").observe(.value, with: { snapshot in
            
            if snapshot.exists() {
            }else{
                
                self.channelRef.child("\(self.groupIdArray[Tag])" )
                
            }
            
            
        })
        Image.img = ""
        Image.hide = "0"
        //Image.mateFlickID = ""
        Image.selectedID = "\(self.groupIdArray[Tag])"
        let chann = Channel(id: "\(self.groupIdArray[Tag])" , name: self.groupNameArray[Tag])
        self.performSegue(withIdentifier: "show", sender: chann)
        
    }
    
    func getFriendsData(){
        
        let url = URL(string: "http://api.mateflick.host/AccountDetails/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&myAccountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    //print("response",json)
                    
                    if let arrJSON = json["friends"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let firstName = array["firstName"] as! String
                            let profilePic = array["profilePic"] as! String
                            let friendAccountId = array["friendAccountId"] as! String
                            
                            self.friendFirstNameArray.append(firstName)
                            self.friendProfilePicArray.append(profilePic)
                            self.friendAccountIdArray.append(friendAccountId)
                            
                            
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.friendsTableView.reloadData()
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    func getGroupData(){
        //                                    self.groupNameArray.removeAll()
        //                                    self.groupIdArray.removeAll()
        //                                    self.groupPicArray.removeAll()
        let url = URL(string: "http://api.mateflick.host/GroupList/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("GroupList",json)
                    self.refreshController.beginRefreshing()
                    if let arrJSON = json["GroupList"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let groupName = array["groupName"] as! String
                            let groupId = array["groupId"] as? Int
                            
                            self.groupNameArray.append(groupName)
                            self.groupIdArray.append(groupId!)
                            // self.groupPicArray.append(aObject["groupPic"] as! String)
                            
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.groupTableView.reloadData()
                        self.refreshController.endRefreshing()
                    }
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    func getConnectsData(){
        
        let url = URL(string: "http://api.mateflick.host/ActiveChatSession/Default.aspx?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    //print("response",json)
                    
                    if let arrJSON = json["ActiveChatSession"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let name = array["name"] as! String
                            let SessionName = array["SessionName"] as! String
                            let profilePic = array["profilePic"]  as AnyObject
                            let senderId = array["senderId"] as AnyObject
                            let typeId = array["typeId"] as! String
                            let Type = array["Type"] as! String
                            
                            self.connectsNameArray.append(name)
                            self.connectsSessionNameArray.append(SessionName)
                            self.connectsProfilePicArray.append(profilePic)
                            self.connectsSenderIdArray.append(senderId)
                            self.connectsTypeIdArray.append(typeId)
                            self.connectsTypeArray.append(Type)
                            
                            
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.connectsTableView.reloadData()
                    }
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    func getCallsData(){
        
        let parameters = ["accountId":String( describing: UserDefaults.standard.integer(forKey: "id"))
            ] as Dictionary<String, String>
        let url = URL(string: "http://api.mateflick.host/CallList/")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("Responce",json)
                    
                    
                    //self.responseDict = json["response"] as! [String: Any]
                    if let arrJSON = json["callList"] {
                        for array in arrJSON as! [Dictionary<String, Any>] {
                            
                            let autoId = array["autoId"] as? Int
                            let toAccountId = array["toAccountId"] as! String
                            let firstname = array["firstname"]  as! String
                            let profilePic = array["profilePic"] as! String
                            let callType = array["callType"] as! String
                            let datetime = array["datetime"] as! String
                            let status = array["status"] as! String
                            let duration = array["duration"] as! String
                            
                            
                            
                            self.callautoId.append(autoId!)
                            self.calltoAccountId.append(toAccountId)
                            self.callfirstname.append(firstname)
                            self.callprofilePic.append(profilePic)
                            self.callcallType.append(callType)
                            self.calldatetime.append(datetime)
                            self.callstatus.append(status)
                            self.callduration.append(duration)
                            
                            
                        }
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.callsTableView.reloadData()
                        
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @IBAction func groupMemberActionBtn(_ sender: AnyObject) {
        
        let GMVC = self.storyboard?.instantiateViewController(withIdentifier: "groupMember") as! GroupMemberViewController
        GMVC.groupIDS = self.groupIdArray[sender.tag]
        self.navigationController?.pushViewController(GMVC, animated: true)
        
        
    }
    
    func groupIDsDataFetch() {
        Image.groupIDsArray.removeAll()
        let url = URL(string: "http://api.mateflick.host/groupDetails/?groupId="+self.groupIDStr)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    //print("memAcId",json)
                    if let arrJSON = json["data"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let memAcId = array["memAcId"] as! String
                            Image.groupIDsArray.append(memAcId)
                            
                            
                        }
                        
                    }
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    @IBAction func callsCallActionBtn(_ sender: AnyObject) {
    }
    override func viewDidAppear(_ animated: Bool) {
        self.awakeFromNib()
    }
    func client() -> SINClient {
        return ((UIApplication.shared.delegate as? AppDelegate)?.client!)!
    }
    func client(_ client: SINCallClient, didReceiveIncomingCall call: SINCall) {
        let CVC = self.storyboard?.instantiateViewController(withIdentifier: "ACVC") as! CallViewController
        CVC.call = call
        self.present(CVC, animated: true, completion: nil)
        
        
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.client().call().delegate = self
    }

    
}
