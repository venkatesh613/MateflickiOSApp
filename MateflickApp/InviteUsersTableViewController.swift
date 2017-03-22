//
//  InviteUsersTableViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 21/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import AFNetworking



class InviteUsersTableViewController: UITableViewController {

    
    var names = [String]()
    var numbers = [String]()
    var autoId = [Int]()
    var autoId1: String = "1"
    var isDelete: Bool = false
    
    @IBOutlet var inviteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.contactListData()
        self.inviteTableView.delegate = self
        self.inviteTableView.dataSource = self
        
    
    }
    
    func updateContactList()
    {
        
        let parameters1 = ["accountId":"2400007",
                           "type":"1",
                           "contectId":self.autoId1] as Dictionary<String, Any>
        print("Update",parameters1,self.autoId)
        let url = URL(string: "http://api.mateflick.host/InvitecontactList/")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters1, options: .prettyPrinted)
            
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
                    
                    var responseArray = [String: Any]()
//                     self.names = [String]()
//                     self.numbers = [String]()
//                     self.autoId = [Int]()
                    responseArray = json
                    print("response from server\(responseArray)")
                    if let arrayData = responseArray["List"]
                    {
                        
                        for index in arrayData as! [Dictionary<String, Any>]
                        {
                            
                            let name: String = index["name"] as! String
                            let number: String = index["mobile"] as! String
                            let id: Int = index["autoId"] as! Int
                            
                            self.autoId1 = String(id)
                            
                            self.names.append(name)
                            self.numbers.append(number)
                            self.autoId.append(id)
                            
                            
                        }
                        
                        
                        print("Name And Numbers",self.names,self.numbers)
                        
                        
                        
                    }
                    
                    self.inviteTableView.reloadData()
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        
    }
    
    func contactListData()
    {
        let parameters1 = ["accountId":"2400007",
                           "type":"1",
                           "contectId":self.autoId1] as Dictionary<String, Any>
        print("dgyfcdsf",parameters1,self.autoId1)
        let url = URL(string: "http://api.mateflick.host/InvitecontactList/")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters1, options: .prettyPrinted)
            
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
                    
                    var responseArray = [String: Any]()
                    
                    responseArray = json
                    print("response from server\(responseArray)")
                    if let arrayData = responseArray["List"]
                    {
                        
                        for index in arrayData as! [Dictionary<String, Any>]
                        {
                            
                            let name: String = index["name"] as! String
                            let number: String = index["mobile"] as! String
                            let id: Int = index["autoId"] as! Int

                            
                            self.autoId1 = String(id)
                            self.names.append(name)
                            self.numbers.append(number)
                            self.autoId.append(id)
                            
                        }
                       
                        
                        print("Name And Numbers",self.names,self.numbers)
                        
                        
                        
                    }

                    self.inviteTableView.reloadData()
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.names.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InviteUsersTableViewCell

        cell.nameText.text = self.names[indexPath.row]
        cell.mobile.text = self.numbers[indexPath.row]
        
        var data: String
        var lastObject: String
        
        data = self.names[indexPath.row]
        lastObject = self.names .last!
        
        print("last object",lastObject)
        
        cell.invite.tag = indexPath.row
        if(cell.invite.isTouchInside == true)
        {
            cell.invite.setTitle("Invited", for: UIControlState.normal)
            
        }
        
        
        
      if(data == lastObject && indexPath.row == self.names.count-1)
      {
        self.updateContactList()
        
        }
        

        return cell
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
    
    @IBAction func inviteUserBtn(_ sender: AnyObject) {
        
        print("\(sender.tag)")
        self.isDelete = true
     
      
        
        let name: String = self.names[sender.tag]
        let mobileNo: String = self.numbers[sender.tag]
        
        self.names.remove(at: sender.tag)
        self.numbers.remove(at: sender.tag)
        
        
        ///post invite Message
        let parameters12 = ["mfAccountId": String(describing: UserDefaults.standard.integer(forKey: "id")),
                           "mobileNo":mobileNo,
                           "name":name] as Dictionary<String, Any>
        print("Invite Contact",parameters12)
        let url = URL(string: "http://api-v2.mateflick.host/json/invite-friends/")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters12, options: .prettyPrinted)
            
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
                    
                    var responseArray = [String: Any]()
                    
                    responseArray = json
                    print("response from server\(responseArray)")
                    
                   // self.inviteTableView.reloadData()
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        
        
        self.tableView.reloadData()
        
    }
    
    

    
    
}
