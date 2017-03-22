//
//  GroupMemberViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 01/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit


class GroupMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, SINCallClientDelegate {
    
    
    @IBOutlet weak var myTableView: UITableView!

    var membershipType = [String]()
    var firstName = [String]()
    var profilePic = [String]()
    var groupIDS = Int()
    var ownerId = String()
    var GroupName = String()
    var btn1 = UIButton()
    var btn2 = UIButton()
    
    //Posted
    var ProfilePicArray = [String]()
    var autoIdArray = [Int]()
    var birthdayIn = [String]()
    var FeedStatusArray = [String]()
    var ownerNameArray = [String]()
    var NoOfLikesArray = [Int]()
    var NoOfCommentsArray = [Int]()
    var textArray = [String]()
    var dateTimeArray = [String]()
    var PostedOnIDArray = [String]()
    var fileNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataFetch()
        groupDetailsDataFetch()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
       
        btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "logout"), for: .normal)
        //btn1.setTitle("Add", for: .normal)
        btn1.setTitleColor(UIColor.white, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //btn1.addTarget(self, action: #selector(Class.Methodname), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        
        btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "invite"), for: .normal)
        btn2.backgroundColor = UIColor.white
        //btn2.setTitle("Delete", for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.setTitleColor(UIColor.white, for: .normal)
        //btn2.addTarget(self, action: #selector(Class.MethodName), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        
        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            return autoIdArray.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }else if indexPath.section == 1 {
            return 100
        }else {
            if (self.fileNameArray[indexPath.row] == "") {
                return 150
            }
            else {
                return 330
            }

        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.membershipType.count
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mind", for: indexPath) as! GroupMemberOnMindTableViewCell
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "collection", for: indexPath) as! GroupMemberCollectionTableViewCell
            
            cell.myCollectionView.reloadData()
            return cell
        }else{
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "status", for: indexPath) as! GroupMemberPostedTableViewCell
            
            if (self.fileNameArray[indexPath.row] == "") {
                cell.lowerLikeBtn?.isHidden = true
                cell.lowerCommentBtn?.isHidden = true
                cell.lowerLikeLabel?.isHidden = true
                cell.lowerCommentLabel?.isHidden = true
                cell.lowerFlickBtn?.isHidden = true
                
                cell.postedImageView?.isHidden = true
                
                cell.upperLikeBtn?.isHidden = false
                cell.upperLikelabel?.isHidden = false
                cell.upperCommentBtn?.isHidden = false
            }else{
                cell.lowerLikeBtn?.isHidden = false
                cell.lowerCommentBtn?.isHidden = false
                cell.lowerLikeLabel?.isHidden = false
                cell.lowerCommentLabel?.isHidden = false
                cell.lowerFlickBtn?.isHidden = false
                
                cell.postedImageView?.isHidden = false
                
                cell.upperLikeBtn?.isHidden = true
                cell.upperLikelabel?.isHidden = true
                cell.upperCommentBtn?.isHidden = true
                cell.upperCommentLabel?.isHidden = true
                cell.upperFlickBtn?.isHidden = true
            }
            if (self.FeedStatusArray[indexPath.row] == "false") {
                cell.lowerLikeBtn?.setBackgroundImage(UIImage(named: "love2"), for: .normal)
                cell.upperLikeBtn?.setBackgroundImage(UIImage(named: "love2"), for: .normal)
                cell.lowerLikeLabel?.text = "\(self.NoOfLikesArray[indexPath.row])"
                cell.upperLikelabel?.text = "\(self.NoOfLikesArray[indexPath.row])"
            }else{
                if !("\(self.NoOfLikesArray[indexPath.row])" == "1") {
                    cell.lowerLikeLabel?.text = "You and \(self.NoOfLikesArray[indexPath.row]) other"
                    cell.upperLikelabel?.text = "You and \(self.NoOfLikesArray[indexPath.row]) other"
                    cell.lowerLikeBtn?.setBackgroundImage(UIImage(named: "like"), for: .normal)
                    cell.upperLikeBtn?.setBackgroundImage(UIImage(named: "like"), for: .normal)
                    
                }else if ("\(self.NoOfLikesArray[indexPath.row])" == "1") {
                    cell.lowerLikeLabel?.text = "You"
                    cell.upperLikelabel?.text = "You"
                    cell.lowerLikeBtn?.setBackgroundImage(UIImage(named: "like"), for: .normal)
                    cell.upperLikeBtn?.setBackgroundImage(UIImage(named: "like"), for: .normal)
                }
            }
            // tag value for like
            
            cell.upperLikeBtn.tag = indexPath.row
            cell.lowerLikeBtn.tag = indexPath.row
            cell.postDeleteBtn.tag = indexPath.row
            
            cell.upperLikeBtn?.addTarget(self, action: #selector(self.btnUpperClick), for: .touchUpInside)
            cell.lowerLikeBtn?.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
            
            //tag valus for comments
            
            cell.upperCommentBtn.tag = indexPath.row
            cell.lowerCommentBtn.tag = indexPath.row
            
            cell.postedTimeLabel?.text = "\(self.dateTimeArray[indexPath.row])"
            cell.birthDayLabel?.text = "\(self.birthdayIn[indexPath.row])"
            cell.lowerCommentLabel?.text = "\(self.NoOfCommentsArray[indexPath.row])"
            cell.upperCommentLabel?.text = "\(self.NoOfCommentsArray[indexPath.row])"
            cell.statusLabel?.text = "\(self.textArray[indexPath.row])"
            cell.userNameBtn?.setTitle(self.ownerNameArray[indexPath.row], for: .normal)
            
            if  let url = NSURL(string: self.ProfilePicArray[indexPath.row]) {
                if let data = NSData(contentsOf: url as URL){
                    cell.userImageView?.image = UIImage(data: data as Data)
                }
            }
            if  let url = NSURL(string: self.fileNameArray[indexPath.row]) {
                if let data = NSData(contentsOf: url as URL){
                    cell.postedImageView?.image = UIImage(data: data as Data)
                }
            }
            
            self.myTableView.allowsSelection = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GroupmemberCollectionViewCell
        if self.membershipType[indexPath.row] == "Owner" {
            cell.removeActionBtn.isHidden = true
        }else{
            cell.removeActionBtn.isHidden = false
        }
        cell.userNameLabel.text = self.firstName[indexPath.row]
        cell.userTypeLabel.text = self.membershipType[indexPath.row]
        
        if  let url = NSURL(string: self.profilePic[indexPath.row]) {
            if let data = NSData(contentsOf: url as URL){
                cell.userImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
                
            }
        }
        
        
        return cell
    }
    
    func groupDetailsDataFetch() {
        
        let url = URL(string: "http://api.mateflick.host/groupDetails/?groupId="+"\(self.groupIDS)")
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    let array = json["response"] as! [String: AnyObject]
                    self.ownerId = array["ownerId"] as! String
                    self.GroupName = array["GroupName"] as! String
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        if self.ownerId == String( describing: UserDefaults.standard.integer(forKey: "id")) {
                            
                            self.btn1.isHidden = false
                            self.btn2.isHidden = false
                        }else{
                            self.btn1.isHidden = true
                            self.btn2.isHidden = true
                        }
                        self.myTableView.reloadData()
                    }
                    if let arrJSON = json["data"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let membershipType = array["membershipType"] as! String
                            let firstName = array["firstName"] as! String
                            let profilePic = array["profilePic"] as! String
                            
                            self.membershipType.append(membershipType)
                            self.firstName.append(firstName)
                            self.profilePic.append(profilePic)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                //let cell = GroupMemberCollectionTableViewCell()
                               //cell.myCollectionView.reloadData()
                                self.myTableView.reloadData()
                            }
                           
                        }
                        
                    }
                    
                    
                    
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    @IBAction func userDetailsactionBtn(_ sender: AnyObject) {
    }

    @IBAction func removeActionBtn(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title:nil, message:nil , preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            let parameters = ["accountId":String( describing: UserDefaults.standard.integer(forKey: "id")),
                              "groupId":"\(self.groupIDS)",
                "type":"self"] as Dictionary<String, String>
            let url = URL(string: "http://api.mateflick.host/GroupMemberRemove/?")!
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
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            
                            //                        if (self.responseDict["status"] as! String) == "fail" {
                            //
                            //                            let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDict["msg"] as? String , preferredStyle: .alert)
                            //                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            //                            })
                            //                            alertController.addAction(ok)
                            //
                            //                            self .present(alertController, animated: true, completion: nil)
                            //
                            //                        }
                            //                            
                            //                        else{
                            //                          
                            //                        }
                            
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
         self.dismiss(animated: true, completion: nil)
            
        })
        alertController.addAction(ok)
        
        self .present(alertController, animated: true, completion: nil)
        
        
    }
func userDataFetch() {
        
        let url = URL(string: "http://api.mateflick.host/GroupFeeds/?groupId="+"\(self.groupIDS)"+"&accountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    if let arrJSON = json["GroupFeeds"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let birthdayIn = array["birthdayIn"] as! String
                            let ownerName = array["ownerName"] as! String
                            let profilePic = array["profilePic"] as! String
                            let autoId = array["autoId"] as? Int
                            let FeedStatus = array["FeedStatus"] as! String
                            let dateTime = array["dateTime"] as! String
                            let NoOfLikes = array["NoOfLikes"] as? Int
                            let NoOfComments = array["NoOfComments"] as? Int
                            let text = array["text"] as! String
                            let fileName = array["fileName"] as! String
                            
                            // birthDay calculation
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMM dd yyyy hh:mma"
                            let birthDay: Date? = dateFormatter.date(from: birthdayIn)
                            dateFormatter.dateFormat = "MMM dd yyyy hh:mma"
                            dateFormatter.timeZone = NSTimeZone.system
                            
                            let cal = Calendar.current
                            
                            var components = cal.dateComponents([.era, .year, .month, .day], from: NSDate() as Date)
                            let today = cal.date(from: components)
                            components = cal.dateComponents([Calendar.Component.day], from: (today! as Date) , to: birthDay! )
                            let compont = (components.day! - 1)
                            var BDStr = String()
                            if compont == 364 {
                                BDStr = "Today"
                            }
                            else {
                                BDStr = "\(compont) Day's"
                            }
                            
                            //posted time
                            var cal2 = Calendar.current
                            
                            var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
                            
                            let dateFormatter2 = DateFormatter()
                            dateFormatter2.dateFormat = "MMM dd yyyy HH:mm:ss:SSSa"
                            let postedTime: Date? = dateFormatter2.date(from: dateTime)
                            dateFormatter2.dateFormat = "MMM dd yyyy HH:mm:ss:SSSa"
                            //dateFormatter2.timeZone = NSTimeZone.system
                            var components2 = cal2.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: NSDate() as Date)
                            let today2 = cal2.date(from: components2)
                            components2 = cal2.dateComponents([Calendar.Component.second], from: postedTime!, to: (today2! as Date) )
                            print("(today as Date)",(today2! as Date))
                            var dateTimeStr = String()
                            let sec = components2.second!
                            let min = sec/60
                            let hour = sec/3600
                            print("Sec",sec)
                            
                            if sec < 60 {
                                dateTimeStr = "\(sec) Sec"
                            }
                            else if min < 60 {
                                dateTimeStr = "\(min) Min"
                            }
                            else if hour < 12 {
                                dateTimeStr = "\(hour) Hr"
                            }
                            else if hour < 24 {
                                dateTimeStr = "Today"
                            }
                            else if hour < 48 {
                                dateTimeStr = "Yesterday"
                            }
                            else {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMM dd yyyy HH:mm:ss:SSSa"
                                let yourDate: Date? = dateFormatter.date(from: dateTime)
                                dateFormatter.dateFormat = "dd MMM yyyy"
                                dateTimeStr = "\(dateFormatter.string(from: yourDate!))"
                            }
                            
                            self.ownerNameArray.append(ownerName)
                            self.ProfilePicArray.append(profilePic)
                            self.autoIdArray.append(autoId!)
                            self.FeedStatusArray.append(FeedStatus)
                            self.dateTimeArray.append(dateTimeStr)
                            self.NoOfLikesArray.append(NoOfLikes!)
                            self.NoOfCommentsArray.append(NoOfComments!)
                            self.textArray.append(text)
                            self.fileNameArray.append(fileName)
                            self.birthdayIn.append(BDStr)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                
                                self.myTableView.reloadData()
                            }
                            
                        }
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    func btnUpperClick(_ sender: Any) {
        
        let button: UIButton? = (sender as? UIButton)
        var indexpath = IndexPath(row: (button?.tag)!, section: 2)
        let cell: WallPostedTableViewCell? = (self.myTableView.cellForRow(at: indexpath) as? WallPostedTableViewCell)
        let specialistID: String? = "\(self.autoIdArray[indexpath.row])"
        if (button!.currentBackgroundImage?.isEqual(UIImage(named: "like")))! && (cell?.upperLikelabel.text == "You") {
            cell?.upperLikeBtn.setBackgroundImage(UIImage(named: "love2"), for: .normal)
            cell?.upperLikelabel.text = "0"
            
            let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=false")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        print("response",json)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            //                            self.NoOfLikesArray.removeAll()
                            //                            self.FeedStatusArray.removeAll()
                            //                            self.userLikeDataFetch()
                            //self.myTableView.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
        }else if (button!.currentBackgroundImage?.isEqual(UIImage(named: "like")))! && !(cell?.upperLikelabel.text == "You") {
            cell?.upperLikeBtn.setBackgroundImage(UIImage(named: "love2"), for: .normal)
            cell?.upperLikelabel.text = "\(self.NoOfLikesArray[indexpath.row])"
            let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=false")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        print("response",json)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            //                            self.NoOfLikesArray.removeAll()
                            //                            self.FeedStatusArray.removeAll()
                            //                            self.userLikeDataFetch()
                            //self.myTableView.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
        }else {
            
            if (button?.currentBackgroundImage?.isEqual(UIImage(named: "love2")))! && (cell?.upperLikelabel.text == "0") {
                cell?.upperLikeBtn.setBackgroundImage(UIImage(named: "like"), for: .normal)
                cell?.upperLikelabel.text = "You"
                
                let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=true")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                            print("response",json)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                //                                self.NoOfLikesArray.removeAll()
                                //                                self.FeedStatusArray.removeAll()
                                //                                self.userLikeDataFetch()
                                //self.myTableView.reloadData()
                            }
                            
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
            } else if (button?.currentBackgroundImage?.isEqual(UIImage(named: "love2")))! && !(cell?.upperLikelabel.text == "0") {
                cell?.upperLikeBtn.setBackgroundImage(UIImage(named: "like"), for: .normal)
                cell?.upperLikelabel.text = "You and \(self.NoOfLikesArray[indexpath.row]) other"
                
                let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=true")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                            print("response",json)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                //                                self.NoOfLikesArray.removeAll()
                                //                                self.FeedStatusArray.removeAll()
                                //                                self.userLikeDataFetch()
                                //self.myTableView.reloadData()
                            }
                            
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
            }
        }
        
    }
    
    func btnClick(_ sender: Any) {
        
        let button: UIButton? = (sender as? UIButton)
        var indexpath = IndexPath(row: (button?.tag)!, section: 2)
        let cell: WallPostedTableViewCell? = (self.myTableView.cellForRow(at: indexpath) as? WallPostedTableViewCell)
        let specialistID: String? = "\(self.autoIdArray[indexpath.row])"
        if (button!.currentBackgroundImage?.isEqual(UIImage(named: "like")))! && (cell?.lowerLikeLabel.text == "You") {
            cell?.lowerLikeBtn.setBackgroundImage(UIImage(named: "love2"), for: .normal)
            cell?.lowerLikeLabel.text = "0"
            
            let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=false")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        print("response",json)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            //                            self.NoOfLikesArray.removeAll()
                            //                            self.FeedStatusArray.removeAll()
                            //                            self.userLikeDataFetch()
                            //self.myTableView.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
        }else if (button!.currentBackgroundImage?.isEqual(UIImage(named: "like")))! && !(cell?.lowerLikeLabel.text == "You") {
            cell?.lowerLikeBtn.setBackgroundImage(UIImage(named: "love2"), for: .normal)
            cell?.lowerLikeLabel.text = "\(self.NoOfLikesArray[indexpath.row])"
            let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=false")
            URLSession.shared.dataTask(with: url!, completionHandler: {
                (data, response, error) in
                if(error != nil){
                    print("error")
                }else{
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                        print("response",json)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            //                            self.NoOfLikesArray.removeAll()
                            //                            self.FeedStatusArray.removeAll()
                            //                            self.userLikeDataFetch()
                            //self.myTableView.reloadData()
                        }
                        
                    }catch let error as NSError{
                        print(error)
                    }
                }
            }).resume()
            
        }else {
            
            if (button!.currentBackgroundImage?.isEqual(UIImage(named: "love2")))! && (cell?.lowerLikeLabel.text == "0") {
                cell?.lowerLikeBtn.setBackgroundImage(UIImage(named: "like"), for: .normal)
                cell?.lowerLikeLabel.text = "You"
                
                let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=true")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                            print("response",json)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                //                                self.NoOfLikesArray.removeAll()
                                //                                self.FeedStatusArray.removeAll()
                                //                                self.userLikeDataFetch()
                                //self.myTableView.reloadData()
                            }
                            
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
            } else if (button!.currentBackgroundImage?.isEqual(UIImage(named: "love2")))! && !(cell?.lowerLikeLabel.text == "0") {
                cell?.lowerLikeBtn.setBackgroundImage(UIImage(named: "like"), for: .normal)
                cell?.lowerLikeLabel.text = "You and \(self.NoOfLikesArray[indexpath.row]) other"
                
                let url = URL(string: "http://api.mateflick.host/LikeOnFeed/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id"))+"&feedId="+specialistID!+"&likeD=true")
                URLSession.shared.dataTask(with: url!, completionHandler: {
                    (data, response, error) in
                    if(error != nil){
                        print("error")
                    }else{
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                            print("response",json)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                                //                                self.NoOfLikesArray.removeAll()
                                //                                self.FeedStatusArray.removeAll()
                                //                                self.userLikeDataFetch()
                                //self.myTableView.reloadData()
                            }
                            
                        }catch let error as NSError{
                            print(error)
                        }
                    }
                }).resume()
            }
        }
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



