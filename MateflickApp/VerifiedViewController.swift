//
//  VerifiedViewController.swift
//  MateFlick
//
//  Created by sudheer-kumar on 07/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class VerifiedViewController: UIViewController {

    @IBOutlet weak var OTPTextField: UITextField!
    @IBOutlet weak var displayMobileNL: UILabel!
    
    var responseDic = [String: Any]()
    var countryVerifiedStr = String()
    var mobileNStr = String()
    var codeStr = String()
    var OTPCompareArray = [Any]()
    var OTPString = String()
    
    
    
    var countryLabel = UILabel()
    var mobileNLabel = UILabel()
    
       
    override func viewDidLoad() {
        super.viewDidLoad()


        
        self.displayMobileNL.text = self.codeStr + self.mobileNStr
        self.countryLabel.text = self.countryVerifiedStr
        self.mobileNLabel.text = self.mobileNStr
        self.OTPString = String(describing: self.OTPCompareArray[1])
        print("OTP string",self.OTPString)
        

    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func verifyingOTP(_ sender: AnyObject) {
        
        if self.OTPTextField.text != self.OTPString {
            
            let alertController = UIAlertController(title: "SORRY!!!", message: "INVALID OTP" , preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
            
        }else{
            let parameters = [
                    "mobileNo":self.mobileNLabel.text!,
                    "accountId":String(describing: UserDefaults.standard.integer(forKey: "id")),
                    "action":"verified",
                    "country":self.countryLabel.text!] as Dictionary<String, String>
            let url = URL(string: "http://api-v2.mateflick.host/json/otp/")!
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
                        self.responseDic = json["response"] as! [String: Any]
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                            
                            
                                let GVC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenu") as! TabBarController
                                self .present(GVC, animated: true, completion: nil)
                            
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

