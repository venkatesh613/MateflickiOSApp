//
//  VerifyMobileViewController.swift
//  MateFlick
//
//  Created by sudheer-kumar on 05/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class VerifyMobileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    
      @IBOutlet weak var myPickerView: UIPickerView!
    
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var codelabel: UILabel!
    
    @IBOutlet weak var contactTF: UITextField!
    var pickerData = [String: String]()
    var responseDic = [String: Any]()
    var keysArray = [String]()
    var valueArray = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
    
       self.myPickerView.dataSource = self
       self.myPickerView.delegate = self
        
        self.keysArray = [
            "Albania",
            "Algeria" ,
            
            "Andorra" ,
            
            "Angola" ,
            
            "Antarctica" ,
            
            "Argentina" ,
            
            "Armenia" ,
            
            "Aruba" ,
            
            "Australia" ,
            
            "Austria" ,
            
            "Azerbaijan",
            
            "Bahrain" ,
            
            "Bangladesh" ,
            
            "Belarus" ,
            
            "Belgium" ,
            
            "Belize" ,
            
            "Benin" ,
            
            "Bhutan" ,
            
            "Bolivia" ,
            
            "Bosnia and Herzegovina" ,
            
            "Botswana" ,
            
            "Brazil" ,
            
            "British Indian Ocean Territory" ,
            
            "Brunei" ,
            
            "Bulgaria" ,
            
            "Burkina Faso" ,
            "Burundi" ,
            
            "Cambodia" ,
            
            "Cameroon" ,
            
            "Canada" ,
            
            "Cape Verde" ,
            
            "Central African Republic" ,
            
            "Chad" ,
            
            "Chile" ,
            
            "China" ,
            
            "Christmas Island" ,
            
            "Cocos Islands" ,
            
            "Colombia" ,
            
            "Comoros" ,
            
            "Cook Islands" ,
            
            "Costa Rica" ,
            
            "Croatia" ,
            
            "Cuba" ,
            
            "Curacao" ,
            
            "Cyprus" ,
            
            "Czech Republic" ,
            
            "Democratic Republic of the Congo" ,
            
            "Denmark" ,
            
            "Djibouti" ,
            
            "East Timor",
            
            "Ecuador",
            
            "Egypt" ,
            
            "El Salvador" ,
            
            "Equatorial Guinea" ,
            
            "Eritrea" ,
            
            "Estonia" ,
            
            "Ethiopia" ,
            
            "Falkland Islands" ,
            "Faroe Islands" ,
            
            "Fiji" ,
            
            "Finland" ,
            
            "France" ,
            
            "French Polynesia" ,
            
            "Gabon" ,
            "Gambia" ,
            
            "Georgia" ,
            
            "Germany" ,
            
            "Ghana" ,
            
            "Gibraltar" ,
            
            "Greece" ,
            
            "Greenland" ,
            
            "Guatemala" ,
            
            "Guinea" ,
            
            "Guinea-Bissau" ,
            "Guyana" ,
            
            "Haiti" ,
            
            "Honduras" ,
            
            "Hong Kong" ,
            
            "Hungary" ,
            
            "Iceland" ,
            
            "India" ,
            
            "Indonesia" ,
            
            "Iran" ,
            
            "Iraq" ,
            
            "Ireland" ,
            
            "Israel" ,
            
            "Italy" ,
            
            "Ivory Coast" ,
            
            "Japan" ,
            
            "Jordan" ,
            
            "Kazakhstan" ,
            
            "Kenya" ,
            
            "Kiribati" ,
            
            "Kosovo" ,
            
            "Kuwait" ,
            
            "Kyrgyzstan",
            
            "Laos" ,
            
            "Latvia" ,
            
            "Lebanon" ,
            
            "Lesotho" ,
            
            "Liberia" ,
            
            "Libya" ,
            
            "Liechtenstein" ,
            
            
            "Lithuania" ,
            
            "Luxembourg" ,
            
            "Macau" ,
            
            "Macedonia" ,
            
            "Madagascar" ,
            
            "Malawi" ,
            
            "Malaysia" ,
            
            "Maldives" ,
            "Mali" ,
            
            "Malta" ,
            
            "Marshall Islands" ,
            
            "Mauritania" ,
            "Mauritius" ,
            
            "Mayotte" ,
            
            "Mexico" ,
            
            "Micronesia" ,
            
            "Moldova" ,
            
            "Monaco" ,
            
            "Mongolia" ,
            
            "Montenegro" ,
            
            "Morocco" ,
            
            "Mozambique" ,
            
            "Myanmar" ,
            
            "Namibia" ,
            
            "Nauru" ,
            
            "Nepal" ,
            
            "Netherlands" ,
            
            "Netherlands Antilles" ,
            
            "New Caledonia" ,
            
            "New Zealand" ,
            "Nicaragua" ,
            
            "Niger" ,
            
            "Nigeria" ,
            
            
            "Niue" ,
            
            "North Korea" ,
            
            "Norway" ,
            "Oman" ,
            
            "Pakistan" ,
            
            "Palau" ,
            
            "Palestine" ,
            
            "Panama" ,
            
            "Papua New Guinea",
            
            "Paraguay" ,
            
            "Peru" ,
            
            "Philippines" ,
            
            "Pitcairn" ,
            
            "Poland" ,
            "Portugal" ,
            
            "Qatar" ,
            
            "Republic of the Congo" ,
            
            "Reunion" ,
            
            "Romania" ,
            
            
            "Russia" ,
            
            "Rwanda" ,
            
            "Saint Barthelemy" ,
            
            "Saint Helena" ,
            
            "Saint Martin" ,
            
            "Saint Pierre and Miquelon",
            
            "Samoa" ,
            
            "San Marino" ,
            
            "Sao Tome and Principe" ,
            
            "Saudi Arabia",
            
            "Senegal" ,
            
            "Serbia" ,
            
            "Seychelles" ,
            
            "Sierra Leone" ,
            
            "Singapore" ,
            
            "Slovakia" ,
            
            "Slovenia" ,
            
            "Solomon Islands",
            
            "Somalia" ,
            
            
            "South Africa" ,
            
            "South Korea" ,
            
            "South Sudan" ,
            
            "Spain" ,
            
            "Sri Lanka" ,
            
            "Sudan" ,
            
            "Suriname" ,
            
            "Svalbard and Jan Mayen" ,
            
            "Swaziland" ,
            
            "Sweden" ,
            
            "Switzerland" ,
            "Syria" ,
            
            "Taiwan" ,
            
            "Tajikistan" ,
            "Tanzania" ,
            
            "Thailand" ,
            "Togo" ,
            
            "Tokelau" ,
            
            "Tonga" ,
            
            "Tunisia" ,
            
            "Turkey",
            
            "Turkmenistan",
            
            "Tuvalu" ,
            
            "Uganda" ,
            
            "Ukraine" ,
            
            "United Arab Emirates" ,
            "United Kingdom" ,
            
            "United States" ,
            
            "Uruguay" ,
            
            "Uzbekistan" ,
            
            "Vanuatu" ,
            
            "Vatican" ,
            
            "Venezuela",
            
            "Vietnam" ,
            
            "Wallis and Futuna" ,
            
            "Western Sahara" ,
            
            "Yemen" ,
            
            "Zambia" ,
            
            "Zimbabwe" ,
        ]
        self.valueArray = ["+355",
                           "+213",
                           "+376",
                           "+244",
                           "+672 ",
                           
                           "+54 ",
                           
                           "+374 ",
                           
                           "+297 ",
                           
                           "+61 ",
                           
                           "+43 ",
                           
                           "+994 ",
                           
                           "+973 ",
                           
                           "+880 ",
                           
                           "+375 ",
                           
                           "+32 ",
                           
                           "+501 ",
                           
                           "+229 ",
                           
                           "+975 ",
                           
                           "+591 ",
                           
                           "+387 ",
                           
                           "+267 ",
                           
                           "+55 ",
                           
                           "+246 ",
                           
                           "+673 ",
                           
                           "+359 ",
                           
                           "+226 ",
                           "+257 ",
                           
                           "+855 ",
                           
                           "+237 ",
                           
                           "+1 ",
                           
                           "+238 ",
                           
                           "+236 ",
                           
                           "+235 ",
                           
                           "+56 ",
                           
                           "+86 ",
                           
                           "+61 ",
                           
                           "+61 ",
                           
                           "+57 ",
                           
                           "+269 ",
                           
                           "+682 ",
                           
                           "+506 ",
                           
                           "+385 ",
                           
                           "+53 ",
                           
                           "+599 ",
                           
                           "+357 ",
                           
                           "+420 ",
                           
                           "+243 ",
                           
                           "+45 ",
                           
                           "+253 ",
                           
                           "+670 ",
                           
                           "+593 ",
                           
                           "+20 ",
                           
                           "+503 ",
                           
                           "+240 ",
                           
                           "+291 ",
                           
                           "+372 ",
                           
                           "+251 ",
                           
                           "+500 ",
                           "+298 ",
                           
                           "+679 ",
                           
                           "+358 ",
                           
                           "+33 ",
                           "+689 ",
                           "+241 ",
                           "+220 ",
                           
                           "+995 ",
                           
                           "+49 ",
                           
                           "+233 ",
                           "+350 ",
                           
                           "+30 ",
                           
                           "+299 ",
                           
                           "+502 ",
                           
                           "+224 ",
                           
                           "+245 ",
                           "+592 ",
                           
                           "+509 ",
                           
                           "+504 ",
                           
                           "+852 ",
                           
                           "+36 ",
                           
                           "+354 ",
                           
                           "+91 ",
                           
                           "+62 ",
                           
                           "+98 ",
                           
                           "+964 ",
                           
                           "+353 ",
                           
                           "+972 ",
                           
                           "+39 ",
                           
                           "+225 ",
                           
                           "+81 ",
                           
                           "+962 ",
                           
                           "+7 ",
                           
                           "+254 ",
                           
                           "+686 ",
                           
                           "+383 ",
                           
                           "+965 ",
                           
                           "+996 ",
                           
                           "+856 ",
                           
                           "+371 ",
                           
                           "+961 ",
                           
                           "+266 ",
                           
                           "+231 ",
                           
                           "+218 ",
                           
                           "+423 ",
                           
                           
                           "+370 ",
                           
                           "+352 ",
                           "+853 ",
                           "+389 ",
                           "+261 ",
                           
                           "+265 ",
                           
                           "+60 ",
                           
                           "+960 ",
                           "+223 ",
                           
                           "+356 ",
                           "+692 ",
                           
                           "+222 ",
                           "+230 ",
                           
                           "+262 ",
                           
                           "+52 ",
                           
                           "+691 ",
                           
                           "+373 ",
                           
                           "+377 ",
                           
                           "+976 ",
                           
                           "+382 ",
                           
                           "+212 ",
                           
                           "+258 ",
                           
                           "+95 ",
                           
                           "+264 ",
                           
                           "+674 ",
                           
                           "+977 ",
                           
                           "+31 ",
                           
                           "+599 ",
                           
                           "+687 ",
                           
                           "+64 ",
                           "+505 ",
                           
                           "+227 ",
                           
                           "+234 ",
                           
                           
                           "+683 ",
                           
                           "+850 ",
                           
                           "+47 ",
                           "+968 ",
                           
                           "+92 ",
                           
                           "+680 ",
                           
                           "+970 ",
                           
                           "+507 ",
                           
                           "+675 ",
                           
                           "+595 ",
                           
                           "+51 ",
                           
                           "+63 ",
                           
                           "+64 ",
                           
                           "+48 ",
                           "+351 ",
                           
                           "+974 ",
                           
                           "+242 ",
                           
                           "+262 ",
                           
                           "+40 ",
                           
                           
                           "+7 ",
                           
                           "+250 ",
                           
                           "+590 ",
                           
                           "+290 ",
                           
                           "+590 ",
                           
                           "+508 ",
                           
                           "+685 ",
                           
                           "+378 ",
                           
                           "+239 ",
                           
                           "+966 ",
                           
                           "+221 ",
                           
                           "+381 ",
                           
                           "+248 ",
                           
                           "+232 ",
                           
                           "+65 ",
                           
                           "+421 ",
                           
                           "+386 ",
                           
                           "+677 ",
                           
                           "+252 ",
                           
                           
                           "+27 ",
                           
                           "+82 ",
                           
                           "+211 ",
                           "+34 ",
                           
                           "+94 ",
                           
                           "+249 ",
                           
                           "+597 ",
                           
                           "+47 ",
                           
                           "+268 ",
                           
                           "+46 ",
                           
                           "+41 ",
                           "+963 ",
                           
                           "+886 ",
                           
                           "+992 ",
                           "+255 ",
                           
                           "+66 ",
                           "+228 ",
                           
                           "+690 ",
                           
                           "+676 ",
                           
                           "+216 ",
                           
                           "+90 ",
                           
                           "+993 ",
                           "+688 ",
                           
                           "+256 ",
                           
                           "+380 ",
                           
                           "+971 ",
                           "+44 ",
                           
                           "+1 ",
                           
                           "+598 ",
                           
                           "+998 ",
                           
                           "+678 ",
                           
                           "+379 ",
                           
                           "+58 ",
                           
                           "+84 ",
                           
                           "+681 ",
                           
                           "+212 ",
                           
                           "+967 ",
                           
                           "+260 ",
                           
                           "+263 "
        ]

        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView , numberOfRowsInComponent component: Int) -> Int {
        
        return self.keysArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView , titleForRow row: Int , forComponent component: Int) -> String? {
        
        return self.keysArray[row]
            
    }
    
    func pickerView(_ pickerView: UIPickerView , didSelectRow row: Int , inComponent component: Int) {
        
        
        self.countryLabel.isHidden = true
        self.countryLabel.text = self.keysArray[row]
        self.codelabel.text = self.valueArray[row]
        
        
        
    }

    @IBAction func fetchData(_ sender: AnyObject) {
    
        if self.contactTF.text == "" || self.countryLabel.text == "" {
            
            let alertController = UIAlertController(title: "SORRY!!!", message: "Please select properly", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            
            self .present(alertController, animated: true, completion: nil)
            
        }else{
    let parameters = [
        "mobileNo":self.codelabel.text!+self.contactTF.text!,
        "accountId":String(describing: UserDefaults.standard.integer(forKey: "id")),
        "action":"sendOTP",
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
                let OTP = Array(self.responseDic.values)
                print("OTP",OTP[1])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                    if (self.responseDic["status"] as! String) == "fail" {
                        
                        let alertController = UIAlertController(title: "SORRY!!!", message: self.responseDic["msg"] as? String, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        })
                        alertController.addAction(ok)
                        
                        self .present(alertController, animated: true, completion: nil)
                        
                    }else{
                        let  GVC = self.storyboard?.instantiateViewController(withIdentifier: "verified") as! VerifiedViewController
                        GVC.countryVerifiedStr = self.countryLabel.text!
                        GVC.mobileNStr = self.contactTF.text!
                        GVC.codeStr = self.codelabel.text!
                        GVC.OTPCompareArray = OTP
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

}
//    func getData()
//    {
//        //Get method............
//        let url = URL(string: "http://api.mateflick.host/Country/?")!
//        
//
//        URLSession.shared.dataTask(with: url, completionHandler: {
//            (data, response, error) in
//            if(error != nil){
//                print("error")
//            }else{
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
//                    
//                    print(json)
//                    
//                    
//                    OperationQueue.main.addOperation({
//                   
//                    })
//                    
//                }catch let error as NSError{
//                    print(error)
//                }
//                           }
//        }).resume()
//    }
//    
    
}
