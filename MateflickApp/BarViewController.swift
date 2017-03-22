//
//  BarViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 16/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import Charts
import AFNetworking

class BarViewController: UIViewController, SINCallClientDelegate{

    var pieChartCount = [Int]()
    var pieChartDate = [String]()
    var pieChartColorCode = [String]()

    var data = 0
    
    @IBOutlet weak var viewForPie: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(self.data == 0)
        {
        self.forPieChart()
        }
    }

    
    func forPieChart()
    {
        
        viewForPie.centerText = "MetFlick"
        viewForPie.animate(xAxisDuration: 2.0, yAxisDuration: 3.0)
        viewForPie.drawSlicesUnderHoleEnabled = true
        
        
        var str = String()
        var str1 = String()
        var str3 = NSNumber()
        var str4 = NSNumber()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let genderVariable = appDelegate.gender
        let countryVariable = appDelegate.country
        let lowVariable = appDelegate.lowAge
        let highVariable = appDelegate.highAge
        _ = appDelegate.repeat1
        
        
        if let genderVar = genderVariable,let countryVar = countryVariable,let lowVar = lowVariable, let highVar = highVariable
        {
            str = genderVar
            str1 = countryVar
            str3 = lowVar
            str4 = highVar
            
        }
        
//        print("\(str)\(str1)\(str3)\(str4)")
        
        if(appDelegate.repeat1 == 0)
        {
            let manager1 = AFHTTPSessionManager()
            manager1.get("http://api.mateflick.host/BirthdaysonWeekDay/Default.aspx/?accountId=2400007&country=India", parameters: nil, progress: nil, success:
                {(_ task: URLSessionTask, _ responseObject: Any) -> Void in
                    
                    print("response from server\(responseObject)")
                    
                    var responseArray1 = [String: Any]()
                    
                    responseArray1 = responseObject as! [String : Any]
                    print("response from server\(responseArray1)")
                    
                    
                    if let arrayData1 = responseArray1["BirthdaysonWeekDay"]
                    {
                        
                        for index in arrayData1 as! [Dictionary<String, Any>]
                        {
                            
                            let colorCode: String = index["colorCode"] as! String
                            let count: Int = index["count"] as! Int
                            let weekday: String = index["weekday"] as! String
                            
                            self.pieChartDate.append(weekday)
                            self.pieChartCount.append(count)
                            self.pieChartColorCode.append(colorCode)
                            
                        }
                        print(self.pieChartDate)
                        print(self.pieChartColorCode)
                        print(self.pieChartCount)
                        
                        self.setChart1(dataPoints: self.pieChartDate, values: self.pieChartCount)
                        
                    }
                },
                         failure:
                {
                    (operation, error) in
                    print("Error: " + error.localizedDescription)
                    
            })

            
        }
        else
        {
            let parameters2 = ["accountId":"2400007",
                               "gender":str ,
                               "fromAge":str4,
                               "toAge":str3,
                               "country":str1] as Dictionary<String, Any>
            print("dgyfcdsf",parameters2)
            
            let url = URL(string: "http://api.mateflick.host/BirthdaysonWeekDay/?")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters2, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task1 = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print("Responce",json)
                        
                        var responseArray1 = [String: Any]()
                        
                        responseArray1 = json
                        print("response from server\(responseArray1)")
                        if let arrayData1 = responseArray1["BirthdaysonWeekDay"]
                        {
                            
                            for index in arrayData1 as! [Dictionary<String, Any>]
                            {
                                
                                let colorCode: String = index["colorCode"] as! String
                                let count: Int = index["count"] as! Int
                                let weekday: String = index["weekday"] as! String
                                
                                self.pieChartDate.append(weekday)
                                self.pieChartCount.append(count)
                                self.pieChartColorCode.append(colorCode)
                                
                            }
                            print(self.pieChartDate)
                            print(self.pieChartColorCode)
                            print(self.pieChartCount)
                            
                            self.setChart1(dataPoints: self.pieChartDate, values: self.pieChartCount)
                            
                        }

                        
                        
                    }
                    
                }
                
                catch let error
                    
                {
                    print(error.localizedDescription)
                }
            })
            task1.resume()
        }


        
    }

  func setChart1(dataPoints: [String], values: [Int])
      {
        print(self.pieChartDate)
        print(self.pieChartColorCode)
        print(self.pieChartCount)
        
        
        var dataEntries1: [PieChartDataEntry] = []
        
        
        
        for (index1,_) in dataPoints.enumerated()
        {
            
            
            let pieDataEntry1 = PieChartDataEntry(value: Double(values[index1]), label: dataPoints[index1],data:dataPoints[index1] as AnyObject?)
            
            dataEntries1.append(pieDataEntry1)
            
        }
        
        
        print("\(dataEntries1)")
        
        var colors2  = [UIColor]()
        
        for index2 in self.pieChartColorCode
        {
            
            let someColor = UIColor.colorwithHexString(index2, alpha: 8)
            
            colors2.append(someColor!)
            
        }
        
        print("colors\(colors2)")
        
        let chartDataSet = PieChartDataSet(values: dataEntries1, label: "BirthdaysonWeekDay")
        let chartData = PieChartData()
        
        
        chartData.addDataSet(chartDataSet)
        
        chartDataSet.colors = colors2
        viewForPie.data = chartData
        viewForPie.drawEntryLabelsEnabled = false
        
        self.data += 1
        
    }
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.awakeFromNib()
    }
    func client() -> SINClient {
        return ((UIApplication.shared.delegate as? AppDelegate)?.client!)!
    }
    func client(_ client: SINCallClient, didReceiveIncomingCall call: SINCall) {
        let CVC = self.storyboard?.instantiateViewController(withIdentifier: "ACVC") as! CallViewController
        CVC.call = call
       self.present(CVC, animated: true, completion: nil)
        
        
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.client().call().delegate = self
    }



}
