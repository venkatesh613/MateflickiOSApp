//
//  SignInViewController.swift
//  ChatChat
//
//  Created by sudheer-kumar on 30/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit
import Google
import FBSDKLoginKit
import GoogleSignIn
struct signInStruct {
    static var UName = String()
    static var PP = String()
    
}

class SignInViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, GIDSignInDelegate{
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    @IBOutlet weak var faceBookLogInButton: FBSDKLoginButton!
    
    @IBOutlet weak var logInEmailTextField: UITextField!
    
    @IBOutlet weak var logInPasswordTextField: UITextField!
    var value = [String]()
    var name = [String]()
    //struct
    var userName = String()
    var userProfilePicture = String()
    
    
    // var app = AppDelegate()
    var dict : [String : AnyObject]!
    var responseDict = [String: Any]()
    var iconClick : Bool!
    var faceBookKeysDataArray = [AnyObject]()
    var faceBookValusDataArray = [AnyObject]()
    //google
    var GAID = String()
    var GUN = String()
    var GUPI = String()
    var GUEID = String()
    //face
    var FAID = String()
    var FUN = String()
    var FUPI = String()
    var FUEID = String()
    // var appDelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        self.logInEmailTextField.text = userDefaults.object(forKey: "e") as! String?
        self.logInPasswordTextField.text = userDefaults.object(forKey: "p") as! String?
        
        iconClick = true
        //app = UIApplication.shared.delegate as! AppDelegate
        //self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //facebook
        
        faceBookLogInButton.delegate = self
        
        
        //google
        
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance().clientID = "899871912025-aurdj8ee3madfh9q7jq51v6fdcbjen89.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate=self
        
    }
    
    //google
    
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if error != nil
        {
            print(error)
            return
        }
        
        self.GAID.removeAll()
        self.GUN.removeAll()
        self.GUPI.removeAll()
        self.GUEID.removeAll()
        
        self.GAID = user.userID
        self.GUN = user.profile.familyName
        //self.GUPI = (user.profile.imageURL(withDimension: 400) as Any as! String)
        self.GUEID = user.profile.email
        
        self.googlePlus_data_request()
        
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        
        print("disconnected")
    }
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!)
    {
        print("Dispatch")
    }
    //FACEBOOK
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil
        {
            print(error)
            return
        }
        print("successfull logged in ")
        self.getFBUserData()
    }
    
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        print("facebook logout")
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.faceBookKeysDataArray.removeAll()
                    self.faceBookValusDataArray.removeAll()
                    self.dict = result as! [String : AnyObject]
                    //print(result!)
                    //print("facebook data",self.dict)
                    
                    self.faceBookKeysDataArray = Array(self.dict.keys) as [AnyObject]
                    self.faceBookValusDataArray = Array(self.dict.values) as [AnyObject]
                    
                    self.facebook_data_request()
                    
                }
            })
        }
    }
    // Direct logIn
    
    
    
    @IBAction func eyeIconeActionBtn(_ sender: AnyObject) {
        
        if(iconClick == true) {
            self.logInPasswordTextField.isSecureTextEntry = false
            iconClick = false
        } else {
            self.logInPasswordTextField.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    @IBAction func directLogIn(_ sender: AnyObject) {
        
        let parameters = ["email":self.logInEmailTextField.text!,
                          "password":self.logInPasswordTextField.text!] as Dictionary<String, String>
        let url = URL(string: "http://api-v2.mateflick.host/json/login/")!
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
                    
                    
                    self.responseDict = json["response"] as! [String: Any]
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(json["mfaccountid"], forKey: "id")
                        
                        if (self.responseDict["status"] as! String) == "fail" {
                            
                            let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDict["msg"] as? String , preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            })
                            alertController.addAction(ok)
                            
                            self .present(alertController, animated: true, completion: nil)
                            
                        }
                            
                        else{
                            // user details
                            //let profileResponse = json["Profile"]! as! [String: Any]
                            //self.value = [profileResponse["profilePic"]! as! String]
                            //self.name = [profileResponse["firstName"]! as! String]
                            //self.appDelegate.globelArray.addObjects(from: self.value)
                            let profile = json["Profile"] as! [String: Any]
                            self.userName = (profile["firstName"] as? String)!
                            self.userProfilePicture = (profile["profilePic"] as? String)!
                            
                            signInStruct.UName = self.userName
                            signInStruct.PP = self.userProfilePicture
                            print("userName",signInStruct.UName)
                            print("profilePic",signInStruct.PP)
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(self.logInEmailTextField.text, forKey: "e")
                            userDefaults.set(self.logInPasswordTextField.text, forKey: "p")
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": String( describing: UserDefaults.standard.integer(forKey: "id"))])
                            let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! TabBarController
                            self .present(GVC, animated: true, completion: nil)
                            
                            
                            
                        }
                        
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    //Action google plus data..............
    
    func googlePlus_data_request(){
        
        
        let parameters = ["via":"googleplus",
                          "accid":self.GAID ,
                          "name":self.GUN,
                          "profileimage":self.GUPI,
                          "email":self.GUEID] as Dictionary<String, String>
        let url = URL(string: "http://api-v2.mateflick.host/json/RegistrationLogin_new/")!
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
                    
                    print("Google plus responce",json)
                    self.responseDict = json["response"] as! [String: Any]
                    let profileResponse = json["Profile"]! as! [String: Any]
                    let loginstatus = json["loginstatus"]!
                    print("loginstatus",loginstatus)
                    print("profile",profileResponse)
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(json["mfaccountid"], forKey: "id")
                        userDefaults.set(profileResponse["firstName"], forKey: "firstName")
                        
                        if (self.responseDict["status"] as! String) == "fail" {
                            
                            let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDict["msg"] as? String , preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            })
                            alertController.addAction(ok)
                            
                            self .present(alertController, animated: true, completion: nil)
                            
                        }
                        else{
                            if (json["loginstatus"]! as! String) == "dob" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "DOB") as! DOBViewController
                                self .present(GVC, animated: true, completion: nil)
                                
                            } else if (json["loginstatus"]! as! String) == "gender" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "gender") as! GenderViewController
                                self .present(GVC, animated: true, completion: nil)
                            }else if (json["loginstatus"]! as! String) == "verifyOTP" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! VerifyMobileViewController
                                self .present(GVC, animated: true, completion: nil)
                            }else if (json["loginstatus"]! as! String) == "true" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! TabBarController
                                self .present(GVC, animated: true, completion: nil)
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    //Facebook action.....................
    
    func facebook_data_request(){
        
        
        let parameters = ["via":"facebook",
                          "accid":self.faceBookValusDataArray[4] as! String ,
                          "name":self.faceBookValusDataArray[5] as! String,
                          "profileimage":"null",
                          "email":self.faceBookValusDataArray[3] as! String] as Dictionary<String, String>
        let url = URL(string: "http://api-v2.mateflick.host/json/RegistrationLogin_new/")!
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
                    print("Facebook responce",json)
                    
                    self.responseDict = json["response"] as! [String: Any]
                    print("mfaccountid",self.responseDict)
                    let profileResponse = json["Profile"]! as! [String: Any]
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(json["mfaccountid"], forKey: "id")
                        userDefaults.set(profileResponse["firstName"], forKey: "firstName")
                        
                        if (self.responseDict["status"] as! String) == "fail" {
                            
                            let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDict["msg"] as? String , preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            })
                            alertController.addAction(ok)
                            
                            self .present(alertController, animated: true, completion: nil)
                            
                        }
                        else{
                            
                            if (json["loginstatus"]! as! String) == "dob" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "DOB") as! DOBViewController
                                self .present(GVC, animated: true, completion: nil)
                                
                            } else if (json["loginstatus"]! as! String) == "gender" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "gender") as! GenderViewController
                                self .present(GVC, animated: true, completion: nil)
                            }else if (json["loginstatus"]! as! String) == "verifyOTP" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "OTP") as! VerifyMobileViewController
                                self .present(GVC, animated: true, completion: nil)
                            }else if (json["loginstatus"]! as! String) == "true" {
                                
                                let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! TabBarController
                                self .present(GVC, animated: true, completion: nil)
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
