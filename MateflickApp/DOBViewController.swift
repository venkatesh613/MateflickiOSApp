//
//  DOBViewController.swift
//  MateFlick
//
//  Created by sudheer-kumar on 06/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
struct DOBData {
    
    static var DOB = String()
    
}
class DOBViewController: UIViewController  {

    @IBOutlet weak var DOBTextField: UITextField!
    var dateFormatter = DateFormatter()
    var responseDic = [String: Any]()
    
    
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if ProfileData.DOBHide == "1" {
            self.continueBtn.isHidden = true
            self.updateBtn.isHidden = false
            self.navigationItem.title = "Date of birth"
        }else{
            self.continueBtn.isHidden = false
            self.updateBtn.isHidden = true
        }
        
        myDatePicker.addTarget(self, action: #selector(DOBViewController.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        dateFormatter=DateFormatter()
        dateFormatter.dateFormat="dd MMM yyyy"
         self.DOBTextField.isHidden = true
        
        self.navigationItem.title = "Update Date of Birth"
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let backButton = UIBarButtonItem(
            title: "Back",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: nil
        )
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
       
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        self.DOBTextField.text=dateFormatter.string(from: sender.date)
        DOBTextField.text = dateFormatter.string(from: sender.date)
        self.DOBTextField.isHidden = true
        
    }

    
    @IBAction func fetchData(_ sender: AnyObject) {
    

    let parameters = [
        
        "accid":String( describing: UserDefaults.standard.integer(forKey: "id")),
        "dob":self.DOBTextField.text!] as Dictionary<String, String>
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
                print("Json responce::",json)
                self.responseDic = json["response"] as! [String: Any]
                let loginstatus = json["loginstatus"]!
                print("loginstatus",loginstatus)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    if self.DOBTextField.text == "" {
                        
                        let alertController = UIAlertController(title: "SORRY!!!", message: "Please select date of birth", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                        })
                        alertController.addAction(ok)
                        
                        self .present(alertController, animated: true, completion: nil)

                    if (self.responseDic["status"] as! String) == "fail" {
                        
                        let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDic["msg"] as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                        })
                        alertController.addAction(ok)
                        
                        self .present(alertController, animated: true, completion: nil)
                     
                        
                        }
                    }else{
                          if (json["loginstatus"]! as! String) == "gender" {
                            
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
    
    @IBAction func updateDOBActionBtn(_ sender: AnyObject) {
        
        let parameters = [
            
            "accid":String( describing: UserDefaults.standard.integer(forKey: "id")),
            "dob":self.DOBTextField.text!] as Dictionary<String, String>
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
                    print("Json responce::",json)
                    //self.responseDic = json["response"] as! [String: Any]
//                    let loginstatus = json["loginstatus"]!
//                    print("loginstatus",loginstatus)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                        
                        if self.DOBTextField.text == "" {
                            
                            let alertController = UIAlertController(title: "SORRY!!!", message: "Please select date of birth", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
                            })
                            alertController.addAction(ok)
                            
                            self .present(alertController, animated: true, completion: nil)
                        }else{
                            
                            DOBData.DOB = self.DOBTextField.text!
                            self.navigationController!.popViewController(animated: true)
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
