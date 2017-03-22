//
//  LineViewViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 16/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import Charts
import AFNetworking
class LineViewViewController: UIViewController, SINCallClientDelegate {

    var lineChartCount = [Int]()
    var lineChartDate = [String]()
    var months = [String]()
    
    var data = 0;
    @IBOutlet weak var viewForLineChart: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.data == 0)
        {
        self.forLineChart()
        }
    }
    
    func forLineChart()
    {
        viewForLineChart.drawGridBackgroundEnabled = false
        viewForLineChart.leftAxis.drawGridLinesEnabled = false
        viewForLineChart.rightAxis.drawGridLinesEnabled = false
        viewForLineChart.xAxis.drawGridLinesEnabled = false
        viewForLineChart.xAxis.labelPosition = .bottom
        viewForLineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
      
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

        if(appDelegate.repeat2 == 0 )
        {
        let manager2 = AFHTTPSessionManager()
        manager2.get("http://api.mateflick.host/BirthdaysonMonth/Default.aspx/?accountId=2400007&fromAge=100&toAge=0", parameters: nil, progress: nil, success:
            {(_ task: URLSessionTask, _ responseObject: Any) -> Void in
                
                print("response from server\(responseObject)")
                
                var responseArray2 = [String: Any]()
                
                responseArray2 = responseObject as! [String : Any]
                print("response from server\(responseArray2)")
                
                
                if let arrayData2 = responseArray2["BirthdaysonMonth"]
                {
                    
                    for index in arrayData2 as! [Dictionary<String, Any>]
                    {
                        
                        //let colorCode: String = index["colorCode"] as! String
                        let count: Int = index["count"] as! Int
                        let weekday: String = index["month"] as! String
                        
                        self.lineChartDate.append(weekday)
                        self.lineChartCount.append(count)
                        //self.pieChartColorCode.append(colorCode)
                        
                    }
                    print(self.lineChartDate)
                    // print(self.pieChartColorCode)
                    print(self.lineChartCount)
                    
                    self.setChart2(dataPoints: self.lineChartDate, values: self.lineChartCount)
                    
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
            let parameters3 = ["accountId":"2400007",
                               "gender":str ,
                               "fromAge":str4,
                               "toAge":str3,
                               "country":str1] as Dictionary<String, Any>
            print("dgyfcdsf",parameters3)
            
            let url = URL(string: "http://api.mateflick.host/BirthdaysonMonth/?")!
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters3, options: .prettyPrinted)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task2 = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print("Responce",json)
                        
                        var responseArray2 = [String: Any]()
                        
                        responseArray2 = json
                        print("response from server\(responseArray2)")
                        
                        
                        if let arrayData2 = responseArray2["BirthdaysonMonth"]
                        {
                            
                            for index in arrayData2 as! [Dictionary<String, Any>]
                            {
                                
                                //let colorCode: String = index["colorCode"] as! String
                                let count: Int = index["count"] as! Int
                                let weekday: String = index["month"] as! String
                                
                                self.lineChartDate.append(weekday)
                                self.lineChartCount.append(count)
                                //self.pieChartColorCode.append(colorCode)
                                
                            }
                            print(self.lineChartDate)
                            // print(self.pieChartColorCode)
                            print(self.lineChartCount)
                            
                            self.setChart2(dataPoints: self.lineChartDate, values: self.lineChartCount)
                            
                        }
                        
                    }
                    
                }
                    
                catch let error
                    
                {
                    print(error.localizedDescription)
                }
            })
            task2.resume()

        }
        
        
    }
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            var months: [String]! = ["Jan 01", "Jan 03", "Jan 05", "Jan 06", "Jan 08", "Jan 12", "Jan 20", "Jan 21", "Jan 24", "Jan 27"]
            return months[Int(value)]
        }
        
        public func stringForValue1(_ value: Double, axis: AxisBase?) -> String
        {
            var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            return months[Int(value)]
        }
    }

    
    func setChart2(dataPoints: [String], values: [Int]) {
        print(self.lineChartDate)
        print(self.lineChartCount)
        
        
        var dataEntries: [BarChartDataEntry] = []
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        for (index,_) in dataPoints.enumerated()
        {
            let dataEntry = BarChartDataEntry(x: Double(index), y:Double(values[index]),  data:months as AnyObject?)
            dataEntries.append(dataEntry)
            
            
            formato.stringForValue1(Double(index), axis: xaxis)
            
        }
        
        xaxis.valueFormatter = formato
        
        print("\(dataEntries)")
        
        let lineChartDataSet1 = LineChartDataSet(values: dataEntries, label: "BirthdaysonMonth")
        
        //lineChartDataSet1.circleRadius = 4.0
        lineChartDataSet1.drawCirclesEnabled = false
        lineChartDataSet1.mode = .cubicBezier
        lineChartDataSet1.cubicIntensity = 0.2
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.fillColor = UIColor.blue
        let lineChartData = LineChartData(dataSet:lineChartDataSet1)
        viewForLineChart.data = lineChartData
        
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
