//
//  RegisterViewController.swift
//  ChatChat
//
//  Created by sudheer-kumar on 30/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var EMailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    var accid = [AnyObject]()
    var dic = [String: Any]()
    var userDic = [String: Any]()
    var iconClick : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //UserDefaults.standard.removeObject(forKey: "mfaccountid")
        self.EMailTF.delegate = self
        iconClick = true
       
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eyeIconActionBtn(_ sender: AnyObject) {
        
        if(iconClick == true) {
            self.passwordTF.isSecureTextEntry = false
            iconClick = false
        } else {
            self.passwordTF.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    func displayAlertMessage(messageToDisplay: String)
    {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            print("Ok button tapped");
            
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func registerationActionBtn(_ sender: AnyObject) {
        
        if (self .isValidEmailAddress(emailAddressString: self.EMailTF.text!) == false) {
            
            let provideEmailAddress = EMailTF.text
            let isEmailAddressValid = isValidEmailAddress(emailAddressString: provideEmailAddress!)
            if isEmailAddressValid
            {
                print("Email address is valid")
            } else {
                print("Email address is not valid")
                displayAlertMessage(messageToDisplay: "Email address is not valid")
            }
            
            
        }else if self.firstNameTF.text == "" {
            
            let alertController = UIAlertController(title: "SORRY!!!", message: "Enter name!!!" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
            
        }else if self.passwordTF.text == "" {
            let alertController = UIAlertController(title: "SORRY!!!", message: "Enter password!!!" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
        }else{
        let parameters = [
            "via":"register",
            "email":self.EMailTF.text!,
            "password":self.passwordTF.text!,
            "name":self.firstNameTF.text!] as Dictionary<String, String>
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
                    
                    print("Json responce::",json)
                    self.dic = json["response"] as! [String: Any]
                     let loginstatus = json["loginstatus"]!
                     print("loginstatus",loginstatus)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(json["mfaccountid"], forKey: "id")
                        
                        if (self.dic["status"] as! String) == "fail" {
                            
                            let alertController = UIAlertController(title: "SORRY!!!", message: self.dic["msg"] as? String , preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                            })
                            alertController.addAction(ok)
                            
                            self .present(alertController, animated: true, completion: nil)
                            
                        }else{
                            
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
    
    }

