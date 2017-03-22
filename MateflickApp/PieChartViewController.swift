//
//  PieChartViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 15/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import Charts
import AFNetworking


class PieChartViewController: UIViewController, SINCallClientDelegate {

    var months1 = [String]()
    var dataEntry1 = BarChartDataEntry()
    
    var barChartCount1 = [Int]()
    var barChartDate1 = [String]()
    var barChartColorCode1 = [String]()
    
    var data = 0

    @IBOutlet weak var viewForBar: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.data == 0)
        {
        self.forBarChart()
        }
        
    }

    
    //*******FOR BARCHART FILTER
   func forBarChart()
   {
    var str = String()
    var str1 = String()
    var str3 = NSNumber()
    var str4 = NSNumber()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let genderVariable = appDelegate.gender
    let countryVariable = appDelegate.country
    let lowVariable = appDelegate.lowAge
    let highVariable = appDelegate.highAge
    let repeatVariable = appDelegate.repeat
    
    
    if let genderVar = genderVariable,let countryVar = countryVariable,let lowVar = lowVariable, let highVar = highVariable
    {
        str = genderVar
        str1 = countryVar
        str3 = lowVar
        str4 = highVar
        
    }
    
    print("\(str)\(str1)\(lowVariable)\(repeatVariable)")
    
    
    print("\(appDelegate.repeat)\(appDelegate.gender)\(appDelegate.lowAge)")
    
    print("\(genderVariable)\(countryVariable)\(lowVariable)\(repeatVariable)")
    viewForBar.layer.cornerRadius = 4.0
    viewForBar.layer.shadowRadius = 6.0
    viewForBar.clipsToBounds = true
    viewForBar.chartDescription?.enabled = false
    //            viewForBar.chartDescription?.textColor = UIColor.red
    viewForBar.layer.shadowColor = UIColor.black.cgColor
    viewForBar.layer.shadowOpacity = 6
    viewForBar.layer.shadowOffset = CGSize(width: CGFloat(6.0), height: CGFloat(6.0))
    // viewForBar.layer.shadowRadius = 5
    
    viewForBar.xAxis.labelPosition = .bottom
    viewForBar.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    
    viewForBar.rightAxis.enabled = false
    // viewForBar1.leftAxis.enabled = false
    viewForBar.leftAxis.drawGridLinesEnabled = false
    viewForBar.xAxis.drawGridLinesEnabled = false
    
    
    
    if(appDelegate.repeat == 0)
    {
        let manager = AFHTTPSessionManager()
        manager.get("http://api.mateflick.host/TopBirthday/?accountId=2400007&fromAge=120&toAge=0", parameters: nil, progress: nil, success:
            {(_ task: URLSessionTask, _ responseObject: Any) -> Void in
                
                print("response from server\(responseObject)")
                
                var responseArray = [String: Any]()
                
                responseArray = responseObject as! [String : Any]
                print("response from server\(responseArray)")
                
                
                if let arrayData = responseArray["TopBirthday"]
                {
                    
                    for index in arrayData as! [Dictionary<String, Any>]
                    {
                        
                        let colorCode: String = index["colorCode"] as! String
                        let count: Int = index["count"] as! Int
                        let date: String = index["date"] as! String
                        
                        self.barChartDate1.append(date)
                        self.barChartCount1.append(count)
                        self.barChartColorCode1.append(colorCode)
                        
                    }
                    print(self.barChartDate1)
                    print(self.barChartColorCode1)
                    print(self.barChartCount1)
                    
                    self.setChart(dataPoints: self.barChartDate1, values: self.barChartCount1)
                    
                    
                    
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
        
        let parameters1 = ["accountId":"2400007",
                           "gender":str ,
                           "fromAge":str4,
                           "toAge":str3,
                           "country":str1] as Dictionary<String, Any>
        print("dgyfcdsf",parameters1)
        
        let url = URL(string: "http://api.mateflick.host/TopBirthday/?")!
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
                    
                    
                    if let arrayData = responseArray["TopBirthday"]
                    {
                        
                        for index in arrayData as! [Dictionary<String, Any>]
                        {
                            
                            let colorCode: String = index["colorCode"] as! String
                            let count: Int = index["count"] as! Int
                            let date: String = index["date"] as! String
                            
                            self.barChartDate1.append(date)
                            self.barChartCount1.append(count)
                            self.barChartColorCode1.append(colorCode)
                            
                        }
                        print(self.barChartDate1)
                        print(self.barChartColorCode1)
                        print(self.barChartCount1)
                        
                        self.setChart(dataPoints: self.barChartDate1, values: self.barChartCount1)
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    
    
    
    }
    
    
    
    public class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String
        {
            var months: [String]! = ["Jan 01", "Jan 03", "Jan 05", "Jan 06", "Jan 08", "Jan 12", "Jan 20", "Jan 21", "Jan 24", "Jan 27"]
            return months[Int(value)]
        }
//        public func stringForValue1(_ value: Double, axis: YAxis?) -> Int
//        {
//                       return barChartCount2[Int(value)]
//        }
    }
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        //BAR CHART
        
     
        
        print(self.barChartDate1)
        print(self.barChartColorCode1)
        print(self.barChartCount1)
    
        
        
        var dataEntries1: [BarChartDataEntry] = []
        //var dataEntries1: [PieChartDataEntry] = []
        
        let formato:BarChartFormatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
//        let yaxis:YAxis = YAxis()
        
        
        for (index1,_) in dataPoints.enumerated()
        {
            let dataEntry1 = BarChartDataEntry(x: Double(index1), y:Double(Int(values[index1])),  data:months1 as AnyObject?)
            dataEntries1.append(dataEntry1)
            
            formato.stringForValue(Double(index1), axis: xaxis)
            //formato.stringForValue1(Double(Int(values[index1])), axis: yaxis)
            
            print((index1))
            
        }
        xaxis.valueFormatter = formato
        // yaxis.valueFormatter = formato
        
        print("\(dataEntries1)")
        
        
        
        var colors1  = [UIColor]()
        
        for index2 in self.barChartColorCode1
        {
            
            let someColor = UIColor.colorwithHexString(index2, alpha: 8)
            
            colors1.append(someColor!)
            
        }
        
        print("colors\(colors1)")
        
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Top 10 BirthDays")
        let chartData1 = BarChartData()
        chartData1.addDataSet(chartDataSet1)
        chartDataSet1.colors = colors1
        viewForBar.data = chartData1
        viewForBar.xAxis.valueFormatter = xaxis.valueFormatter
        
        
        
       self.data += 1
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func filterButton(_ sender: AnyObject) {
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
