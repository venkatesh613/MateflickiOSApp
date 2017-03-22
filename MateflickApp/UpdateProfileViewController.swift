//
//  UpdateProfileViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 22/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
struct ProfileData {
    static var img = String()
    static var name = String()
    static var DOBHide = String()
    static var genderHide = String()
}
class UpdateProfileViewController: UIViewController {

   
    @IBOutlet weak var userImageBtn: UIButton!
    
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var birthDayBtn: UIButton!
    
    @IBOutlet weak var genderBtn: UIButton!
    
    @IBOutlet weak var mobileNoLabel: UILabel!
    
    @IBOutlet weak var BioTF: UITextField!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    
    var dob = String()
    var image = String()
    var name = String()
    var mobile = String()
    var bio = String()
    var gender = String()
    var dateTimeStr = String()
    var userImageT = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        userDataFetch()
      
        //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let backButton = UIBarButtonItem(
            title: "Back",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        self.title = "Update Profile"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.usernameTF.becomeFirstResponder()
        if DOBData.DOB != "" {
            self.birthDayBtn.setTitle(DOBData.DOB, for: .normal)
                    }
        if GenderData.gender != "" {
            self.genderBtn.setTitle(GenderData.gender, for: .normal)

        }
        if self.userImageT != ""{
        if  let url = NSURL(string: self.userImageT) {
            if let data = NSData(contentsOf: url as URL){
                self.userImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
            }
        }
     }
 
        
    }
    
    @IBAction func DOBActionBtn(_ sender: AnyObject) {
        
        ProfileData.DOBHide = "1"
        let DOBVC = self.storyboard?.instantiateViewController(withIdentifier: "DOB") as! DOBViewController
        self.navigationController?.pushViewController(DOBVC, animated: true)
        
    }

    @IBAction func genderActionBtn(_ sender: AnyObject) {
        
        ProfileData.genderHide = "1"
        let DOBVC = self.storyboard?.instantiateViewController(withIdentifier: "gender") as! GenderViewController
        self.navigationController?.pushViewController(DOBVC, animated: true)
        
    }
    
    @IBAction func saveActionBtn(_ sender: AnyObject) {
        
        
        self.image.removeAll()
        self.name.removeAll()
        self.dob.removeAll()
        self.gender.removeAll()
        self.mobile.removeAll()
        
        
        userNameDataFetch()
        userDataFetch()
        
    }
    @IBAction func changeActionBtn(_ sender: AnyObject) {
    }
    
    
    @IBAction func userImageActionBtn(_ sender: AnyObject) {
    }
    
    func userDataFetch() {
     
        let url = URL(string: "http://api.mateflick.host/UserProfileDetails/?accountId="+String( describing: UserDefaults.standard.integer(forKey: "id")))
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String: AnyObject]
                    print("response",json)
                    
                    if let arrJSON = json["UserProfileDetails"] {
                        for index in arrJSON as! [Dictionary<String, AnyObject>] {
                            
                            let firstName = index["firstName"] as! String
                            let profilePic = index["profilePic"] as! String
                            let dob = index["dob"] as! String
                            let mobileNo = index["mobileNo"] as! String
                            let gender = index["gender"] as! String
                            
                            self.name.append(firstName)
                            self.image.append(profilePic)
                            self.dob.append(dob)
                            self.mobile.append(mobileNo)
                            self.gender.append(gender)
                            
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMM dd yyyy HH:mm:ss:SSSa"
                            let yourDate: Date? = dateFormatter.date(from: self.dob)
                            dateFormatter.dateFormat = "dd MMM yyyy"
                            self.dateTimeStr = "\(dateFormatter.string(from: yourDate!))"
                            
                        }
                    }
                    print("fgh",self.dob)
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        self.usernameTF.text = self.name
                        self.birthDayBtn .setTitle(self.dateTimeStr, for: .normal)
                        self.genderBtn .setTitle(self.gender, for: .normal)
                        self.mobileNoLabel.text = self.mobile
                        if self.bio == "" {
                            
                        }else {
                            self.BioTF.text = self.bio
                        }
                        if  let url = NSURL(string: self.image) {
                            if let data = NSData(contentsOf: url as URL){
                                self.userImageBtn .setBackgroundImage(UIImage(data: data as Data), for: .normal)
                            }
                        }
                      ProfileData.img = self.image
                      ProfileData.name = self.name
                    }
               
                   }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
    func userNameDataFetch() {
        
        let parameters = ["accid":String( describing: UserDefaults.standard.integer(forKey: "id")),
                           "name":self.usernameTF.text!] as Dictionary<String, String>
        let url = URL(string: "http://api-v2.mateflick.host/json/PendingDataPost/")!
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
                    
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
