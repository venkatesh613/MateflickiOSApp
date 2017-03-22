//
//  WallACFeedsViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 25/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class WallACFeedsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SINCallClientDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var IDStr = String()
    //Profile
    var dob = String()
    var image = String()
    var name = String()
    var totalfriend = [Int]()
    var bio = String()
    var totalPost = [Int]()
    var mutualfriend = [Int]()
    var dateTimeStr = String()
    var country = String()
    var accountIdStr = String()
    //Posted
    //var postedDataStoreArray = [String]()
    var ProfilePicArray = [String]()
    //var postedNameArray = [String]()
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
        userProfileDataFetch()
        userDataFetch()
        self.myTableView.delegate = self
        
        self.myTableView.dataSource = self
        print("IDStr",self.IDStr)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
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
        }else {
            return self.autoIdArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let ProfileCellIdentifier = "wallACProfile"
        let StatusCellIdentifier = "wallStatus"
        let postedCellIdentifier = "wallPosted"
        if indexPath.section == 0 {
            //PROFILE............
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCellIdentifier) as! WallACProfileTableViewCell
            cell.roundView.layer.cornerRadius = cell.roundView.frame.size.width / 2;
            cell.roundView.clipsToBounds = true
            //cell.editProfileBtn.layer.cornerRadius = cell.editProfileBtn.frame.size.width / 2
            //cell.editProfileBtn.clipsToBounds = true
            
            var totalfriendStr = String()
            var mutualfriendStr = String()
            var totalPostStr = String()
            
            totalfriendStr = "\(self.totalfriend)"
            totalPostStr = "\(self.totalPost)"
            mutualfriendStr = "\(self.mutualfriend)"
            
            let badchar: NSCharacterSet = NSCharacterSet(charactersIn: "\"[]")
            let cleanedtotalfriendStr: NSString = (totalfriendStr.components(separatedBy: badchar as CharacterSet) as NSArray).componentsJoined(by: "") as NSString
            let cleanedmutualfriendStr: NSString = (mutualfriendStr.components(separatedBy: badchar as CharacterSet) as NSArray).componentsJoined(by: "") as NSString
            let cleanedtotalPostStr: NSString = (totalPostStr.components(separatedBy: badchar as CharacterSet) as NSArray).componentsJoined(by: "") as NSString
            
            cell.userDOBLabel.text = self.dateTimeStr
            cell.friendslabel.text = cleanedtotalfriendStr as String
            cell.postLable.text = cleanedtotalPostStr as String
            cell.mutualfriendsLabel.text = cleanedmutualfriendStr as String
            cell.userNameLabel.text = self.name
            cell.userCountryLabel.text = self.country
            if  let url = NSURL(string: self.image) {
                if let data = NSData(contentsOf: url as URL){
                    cell.userImageView.image = UIImage(data: data as Data)
                }
            }
            if  let url = NSURL(string: self.image) {
                if let data = NSData(contentsOf: url as URL){
                    cell.underImageView.image = UIImage(data: data as Data)
                }
            }
            self.myTableView.allowsSelection = false
            return cell
        }else if indexPath.section == 1 {
            
            //STATUS.............
            
            let cell = tableView.dequeueReusableCell(withIdentifier: StatusCellIdentifier) as! WallStatusTableViewCell
            return cell
            
        }else {
            
            //User Details..........
            
            let cell = tableView.dequeueReusableCell(withIdentifier: postedCellIdentifier) as! WallPostedTableViewCell
            
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
            
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 710
        }else if indexPath.section == 1 {
            return 70
        }else{
            
            if (self.fileNameArray[indexPath.row] == "") {
                return 150
            }
            else {
                return 330
            }
        }
    }
    
    func userProfileDataFetch() {
        
        let url = URL(string: "http://api.mateflick.host/GetUserProfile/?friendAccountId="+self.IDStr+"&myAccountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    
                    if let arrJSON = json["friends"] {
                        
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let accountId = array["accountId"] as! String
                            let firstName = array["firstName"] as! String
                            let profilePic = array["profilePic"] as! String
                            let dob = array["dob"] as! String
                            let totalPost = array["totalPost"] as? Int
                            let totalfriend = array["totalfriend"] as? Int
                            let mutualfriend = array["mutualfriend"] as? Int
                            let country = array["country"] as! String
                            
                            self.accountIdStr.append(accountId)
                            self.name.append(firstName)
                            self.image.append(profilePic)
                            self.dob.append(dob)
                            self.totalPost.append(totalPost!)
                            self.totalfriend.append(totalfriend!)
                            self.mutualfriend.append(mutualfriend!)
                            self.country.append(country)
                            
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            let yourDate: Date? = dateFormatter.date(from: self.dob)
                            dateFormatter.dateFormat = "dd MMM"
                            self.dateTimeStr = "\(dateFormatter.string(from: yourDate!))"
                            
                        }
                    }
                    print("fgh",self.dob)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.myTableView.reloadData()
                    }
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
    
    func userDataFetch() {
        
        let url = URL(string: "http://api.mateflick.host/AcFeeds/?accountId="+self.IDStr)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    if let arrJSON = json["AcFeeds"] {
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
    
    func userLikeDataFetch() {
        
        let url = URL(string: "http://api.mateflick.host/AcFeeds/?accountId="+self.IDStr)
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    if let arrJSON = json["AcFeeds"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            
                            let NoOfLikes = array["NoOfLikes"] as? Int
                            let FeedStatus = array["FeedStatus"] as! String
                            self.NoOfLikesArray.append(NoOfLikes!)
                            self.FeedStatusArray.append(FeedStatus)
                            
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
    
    @IBAction func mutualFriendsActionBtn(_ sender: AnyObject) {
    }
    
    @IBAction func friendsActionBtn(_ sender: AnyObject) {
    }
    
    @IBAction func postActionBtn(_ sender: AnyObject) {
    }
    
    
    @IBAction func unFriendActionBtn(_ sender: AnyObject) {
    }
    
    @IBAction func callActionBtn(_ sender: AnyObject) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": String( describing: UserDefaults.standard.integer(forKey: "id"))])
        
        if (self.accountIdStr != "") && self.client().isStarted() {
            let call: SINCall = self.client().call().callUser(withId: self.accountIdStr)
            self.performSegue(withIdentifier: "callView", sender: call)
        }
        
    }
    
    @IBAction func videoCallActionBtn(_ sender: AnyObject) {
    }
    
    @IBAction func chatActionBtn(_ sender: AnyObject) {
    }
    
    @IBAction func statusActionBtn(_ sender: AnyObject) {
        
        //let PVC = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! PostViewController
        //self.navigationController?.pushViewController(PVC, animated: true)
    }
    func client() -> SINClient {
        return ((UIApplication.shared.delegate as? AppDelegate)?.client!)!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let CVC = segue.destination as! CallViewController
        CVC.call = sender as! SINCall!
    }
    func client(_ client: SINCallClient, didReceiveIncomingCall call: SINCall) {
        self.performSegue(withIdentifier: "callView", sender: call)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.client().call().delegate = self
    }
    
}
