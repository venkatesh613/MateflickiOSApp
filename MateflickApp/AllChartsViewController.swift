//
//  AllChartsViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 11/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import Charts
import AFNetworking

class AllChartsViewController: UIViewController, SINCallClientDelegate
{

    
    var months = [String]()
    var unitsSold = [Int]()

    //var dataEntryPie = PieChartDataEntry()
   
    
    
    var data = 0
    @IBOutlet weak var map: UIView!
   
    @IBOutlet weak var viewForBarChart: BarChartView!
    @IBOutlet weak var viewForPieChart: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!
    
    var dataEntry = BarChartDataEntry()
    
    var barChartCount12 = [Int]()
    var barChartDate12 = [String]()
    var barChartColorCode12 = [String]()
    
    
    var pieChartCount12 = [Int]()
    var pieChartDate12 = [String]()
    var pieChartColorCode12 = [String]()
    
    var lineChartCount12 = [Int]()
    var lineChartDate12 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.data == 0)
        {
            
        dataForCharts()
            
        }
  
        
    }
    
    func dataForCharts()
    {
        
        self.dataEntry = BarChartDataEntry()
        
        self.barChartCount12 = [Int]()
        self.barChartDate12 = [String]()
        self.barChartColorCode12 = [String]()
        
        
        self.pieChartCount12 = [Int]()
        self.pieChartDate12 = [String]()
        self.pieChartColorCode12 = [String]()
        
        self.lineChartCount12 = [Int]()
        self.lineChartDate12 = [String]()
        
        
        
        map.layer.cornerRadius = 4.0
        map.layer.borderWidth = 0.6
        map.layer.borderColor = UIColor.lightGray.cgColor
        
        let data: [String: Any] = ["India": 50, "China": 2, "SriLanka": 5, "Nigeria": 25, "Canada": 5, "Mali": 10]
        
        let map1 = FSInteractiveMapView()
        map1.frame = CGRect(x:0, y:10, width:360, height:240)
        
        self.map.addSubview(map1)
        
        map1.loadMap("world-low", withData: data, colorAxis: [UIColor.white, UIColor.red])
        
        //        map1.clickHandler = {(_ identifier: String, _ layer: CAShapeLayer) -> Void in
        //            self.detailDescriptionLabel.text = "Continent clicked: \(identifier)"
        //        }
        
        //****PieChart
        viewForPieChart.centerText = "MetFlick"
        viewForPieChart.animate(xAxisDuration: 2.0, yAxisDuration: 3.0)
        viewForPieChart.drawSlicesUnderHoleEnabled = true
        viewForPieChart.layer.cornerRadius = 4.0
        viewForPieChart.layer.borderWidth = 1.0
        viewForPieChart.layer.borderColor = UIColor.lightGray.cgColor
        
        
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
                        
                        self.pieChartDate12.append(weekday)
                        self.pieChartCount12.append(count)
                        self.pieChartColorCode12.append(colorCode)
                        
                    }
                    print(self.pieChartDate12)
                    print(self.pieChartColorCode12)
                    print(self.pieChartCount12)
                    
                    self.setChart1(dataPoints: self.pieChartDate12, values: self.pieChartCount12)
                    
                }
            },
                     failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                
        })
        
        
        
        
        
        //****LineChart
        
        lineChart.drawGridBackgroundEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.layer.cornerRadius = 4.0
        lineChart.layer.borderWidth = 0.6
        lineChart.layer.borderColor = UIColor.lightGray.cgColor
        
        
        lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
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
                        
                        self.lineChartDate12.append(weekday)
                        self.lineChartCount12.append(count)
                        //self.pieChartColorCode.append(colorCode)
                        
                    }
                    print(self.lineChartDate12)
                    // print(self.pieChartColorCode)
                    print(self.lineChartCount12)
                    
                    self.setChart2(dataPoints: self.lineChartDate12, values: self.lineChartCount12)
                    
                }
            },
                     failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                
        })
        
        
        
        
        
        //*****BAR CHART
        // setChart(dataPoints: months, values: (unitsSold))
        
        //      (userDefaults.object(forKey:"id"))
        
        viewForBarChart.layer.cornerRadius = 4.0
        viewForBarChart.clipsToBounds = true
        viewForBarChart.chartDescription?.enabled = false
        //            viewForBarChart.chartDescription?.textColor = UIColor.red
        viewForBarChart.layer.shadowColor = UIColor.black.cgColor
        viewForBarChart.layer.shadowOpacity = 0.5
        viewForBarChart.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
        viewForBarChart.layer.shadowRadius = 5
        viewForBarChart.layer.borderWidth = 0.6
        viewForBarChart.layer.borderColor = UIColor.gray.cgColor
        
        
        viewForBarChart.xAxis.labelPosition = .bottom
        viewForBarChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        viewForBarChart.rightAxis.enabled = false
        // viewForBarChart1.leftAxis.enabled = false
        viewForBarChart.leftAxis.drawGridLinesEnabled = false
        viewForBarChart.xAxis.drawGridLinesEnabled = false
        
        
        
        
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
                        
                        self.barChartDate12.append(date)
                        self.barChartCount12.append(count)
                        self.barChartColorCode12.append(colorCode)
                        
                    }
                    print(self.barChartDate12)
                    print(self.barChartColorCode12)
                    print(self.barChartCount12)
                    
                    self.setChart(dataPoints: self.barChartDate12, values: self.barChartCount12)
                    
                    
                    
                }
            },
                    failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                
        })
        
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
    
    func setChart(dataPoints: [String], values: [Int]) {
        
        //BAR CHART
        
        
        
        print(self.barChartDate12)
        print(self.barChartColorCode12)
        print(self.barChartCount12)
        
        
        var dataEntries: [BarChartDataEntry] = []
        //var dataEntries1: [PieChartDataEntry] = []
        
        
        for (index1,_) in dataPoints.enumerated()
        {
            let dataEntry = BarChartDataEntry(x: Double(index1), y:Double(Int(values[index1])),  data:self.barChartDate12 as AnyObject?)
            dataEntries.append(dataEntry)
            
            print((index1))
        }
        
        print("\(dataEntries)")
        
        
        
        var colors1  = [UIColor]()
        
        for index2 in self.barChartColorCode12
        {
            
            let someColor = UIColor.colorwithHexString(index2, alpha: 8)
            
            colors1.append(someColor!)
            
        }
        
        print("colors\(colors1)")
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Top 10 BirthDays")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartDataSet.colors = colors1
        viewForBarChart.data = chartData
        viewForBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.barChartDate12)
        
        
    }
    
    
    //LINE CHART
    func setChart2(dataPoints: [String], values: [Int]) {
        print(self.lineChartDate12)
        print(self.lineChartCount12)
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for (index,_) in dataPoints.enumerated()
        {
            let dataEntry = BarChartDataEntry(x: Double(index), y:Double(values[index]),  data:self.lineChartDate12 as AnyObject?)
            dataEntries.append(dataEntry)
            
        }
        
        print("\(dataEntries)")
        
        let lineChartDataSet1 = LineChartDataSet(values: dataEntries, label: "BirthdaysonMonth")
        
        //lineChartDataSet1.circleRadius = 4.0
        lineChartDataSet1.drawCirclesEnabled = false
        lineChartDataSet1.mode = .cubicBezier
        lineChartDataSet1.cubicIntensity = 0.2
        lineChartDataSet1.drawFilledEnabled = true
        lineChartDataSet1.fillColor = UIColor.blue
        let lineChartData = LineChartData(dataSet:lineChartDataSet1)
        lineChart.data = lineChartData
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.lineChartDate12)
        
        
        
    }
    
    
    
    
    //PIE CHART
    func setChart1(dataPoints: [String], values: [Int]) {
        print(self.pieChartDate12)
        print(self.pieChartColorCode12)
        print(self.pieChartCount12)
        
        
        var dataEntries1: [PieChartDataEntry] = []
        
        
        
        for (index1,_) in dataPoints.enumerated()
        {
            
            
            let pieDataEntry1 = PieChartDataEntry(value: Double(values[index1]), label: dataPoints[index1],data:dataPoints[index1] as AnyObject?)
            
            dataEntries1.append(pieDataEntry1)
            
        }
        
        
        print("\(dataEntries1)")
        
        var colors2  = [UIColor]()
        
        for index2 in self.pieChartColorCode12
        {
            
            let someColor = UIColor.colorwithHexString(index2, alpha: 8)
            
            colors2.append(someColor!)
            
        }
        
        print("colors\(colors2)")
        
        let chartDataSet = PieChartDataSet(values: dataEntries1, label: "BirthdaysonWeekDay")
        let chartData = PieChartData()
        
        
        chartData.addDataSet(chartDataSet)
        
        chartDataSet.colors = colors2
        viewForPieChart.data = chartData
        viewForPieChart.drawEntryLabelsEnabled = false

        
        
    }


    @IBAction func barChartZoomingActionBtn(_ sender: AnyObject) {
    
        
    }
    @IBAction func lineChartZoomActionBtn(_ sender: AnyObject) {
    
        
    }
   
    @IBAction func pieChartZoomingActionBtn(_ sender: AnyObject) {
     
    }

    
}
