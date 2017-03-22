//
//  ChangePasswordViewController.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 24/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    
    
    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    var responseDict = [String: Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Change Password"
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
    
    @IBAction func changePasswordBtn(_ sender: AnyObject) {
        if self.newPasswordTF.text != self.confirmPasswordTF.text {
            let alertController = UIAlertController(title: "SORRY!!!", message: "New password and confirm password should be same!!!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
        }else{
        let parameters = ["accountid":String( describing: UserDefaults.standard.integer(forKey: "id")),
                          "passwordOld":self.oldPasswordTF.text!,
                          "passwordNew":self.newPasswordTF.text!] as Dictionary<String, String>
        let url = URL(string: "http://api-v2.mateflick.host/json/ConfigurePassword/Change/")!
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
                    
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    
                    if (self.responseDict["status"] as! String) == "fail" {
                        
                        let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDict["msg"] as? String , preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        })
                        alertController.addAction(ok)
                        
                        self .present(alertController, animated: true, completion: nil)
                        
                    }else{
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
    
}
