//
//  GroupCreateViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 13/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var myTableView: UITableView!
    var friendAccountIdArray = [String]()
    var friendFirstNameArray = [String]()
    var friendProfilePicArray = [String]()
    var friendEmailID = [String]()
    var selectedRowID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriendsData()
        // Do any additional setup after loading the view.
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.groupNameTextField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendAccountIdArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupCreateTableViewCell
        
        cell.userNameLabel.text! = "\(self.friendFirstNameArray[indexPath.row])"
        cell.userEmailIDLabel.text = "\(self.friendEmailID[indexPath.row])"
        if  let url = NSURL(string: self.friendProfilePicArray[indexPath.row]) {
            if let data = NSData(contentsOf: url as URL){
                cell.userImageView.image = UIImage(data: data as Data)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  myTableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark {
            myTableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
            self.selectedRowID.remove(at:indexPath.row)
        }else{
            myTableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
            self.selectedRowID.append(self.friendAccountIdArray[indexPath.row] )
        }
    }
    
    @IBAction func CreateGroupActionBtn(_ sender: AnyObject) {
        if self.groupNameTextField.text == "" || self.selectedRowID.count<1 {
            
            let alertController = UIAlertController(title: "OOPS!!!", message: "Invalid selection!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
            
        }else{
            
            var parameters: [String: AnyObject] = [:]
            parameters["groupName"] = self.groupNameTextField.text! as AnyObject?
            parameters["ids"] = self.selectedRowID as AnyObject?
            parameters["accountId"] = String( describing: UserDefaults.standard.integer(forKey: "id")) as AnyObject?
            
            
            let url = URL(string: "http://api.mateflick.host/GroupMemberAdd-2/?")!
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
                        print("Responce created group",json)
                        
                        
                        //self.responseDict = json["response"] as! [String: Any]
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            
                            self.navigationController!.popViewController(animated: true)
                            
                            
                        }
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            })
            task.resume()
            
        }
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
                    print("response",json)
                    
                    if let arrJSON = json["friends"] {
                        for array in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let firstName = array["firstName"] as! String
                            let profilePic = array["profilePic"] as! String
                            let friendAccountId = array["friendAccountId"] as! String
                            let emailId = array["emailId"] as! String
                            
                            self.friendFirstNameArray.append(firstName)
                            self.friendProfilePicArray.append(profilePic)
                            self.friendAccountIdArray.append(friendAccountId)
                            self.friendEmailID.append(emailId)
                            
                            
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.myTableView.reloadData()
                    }
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
    }
}
