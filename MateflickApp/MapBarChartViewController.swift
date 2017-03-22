//
//  MapBarChartViewController.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 17/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit
import Charts
import AFNetworking



class MapBarChartViewController: UIViewController , SINCallClientDelegate{
    

    @IBOutlet weak var mapBarView: BarChartView!
    
    var dataEntry = BarChartDataEntry()
    
    var barChartCount = [Int]()
    var barChartDate = [String]()
    
    var data = 0
    override func viewDidLoad() {
        super.viewDidLoad()

   
        if(self.barChartCount.count == 0)
        {
            dataForChart()
        }
        
        
    }
    
    func dataForChart()
    {
        mapBarView.layer.cornerRadius = 4.0
        mapBarView.layer.shadowRadius = 6.0
        mapBarView.clipsToBounds = true
        mapBarView.chartDescription?.enabled = false
        //            mapBarView.chartDescription?.textColor = UIColor.red
        mapBarView.layer.shadowColor = UIColor.black.cgColor
        mapBarView.layer.shadowOpacity = 6
        mapBarView.layer.shadowOffset = CGSize(width: CGFloat(6.0), height: CGFloat(6.0))
        // mapBarView.layer.shadowRadius = 5
        
        mapBarView.xAxis.labelPosition = .bottom
        mapBarView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        mapBarView.rightAxis.enabled = false
        // mapBarView1.leftAxis.enabled = false
        mapBarView.leftAxis.drawGridLinesEnabled = false
        mapBarView.xAxis.drawGridLinesEnabled = false
        
        
        
        
        let manager = AFHTTPSessionManager()
        manager.get("http://api.mateflick.host/GeoChartWorldMap/Default.aspx?accountId=2400007&gender=male", parameters: nil, progress: nil, success:
            {(_ task: URLSessionTask, _ responseObject: Any) -> Void in
                
                print("response from server\(responseObject)")
                
                var responseArray = [String: Any]()
                
                responseArray = responseObject as! [String : Any]
                print("response from server\(responseArray)")
                
                
                if let arrayData = responseArray["userAccount"]
                {
                    
                    for index in arrayData as! [Dictionary<String, Any>]
                    {
                        
                        
                        let count: Int = index["userCount"] as! Int
                        let date: String = index["country"] as! String
                        
                        self.barChartDate.append(date)
                        self.barChartCount.append(count)
                        
                        
                    }
                    print(self.barChartDate)
                    print(self.barChartCount)
                    
                    self.setChart(dataPoints: self.barChartDate, values: self.barChartCount)
                    
                    
                    
                }
            },
                    failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
                
        })
        
        self.data += 1
        

    }
    func setChart(dataPoints: [String], values: [Int]) {
        
    
        print(self.barChartDate)
        print(self.barChartCount)
        var dataEntries: [BarChartDataEntry] = []
        
        
        for (index1,_) in dataPoints.enumerated()
        {
            let dataEntry = BarChartDataEntry(x: Double(index1), y:Double(Int(values[index1])),  data:self.barChartDate as AnyObject?)
            dataEntries.append(dataEntry)
            
            print((index1))
            
        }
      
        
        print("\(dataEntries)")
        
    
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "WorldMetflick")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartDataSet.colors = [UIColor.red]
        mapBarView.data = chartData
        mapBarView.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.barChartDate)
        mapBarView.xAxis.granularity = 1
    
        
//        mapBarView.data?.setValueFormatter(IndexAxisValueFormatter(values:self.barChartCount as! [String]))
        
        print("sdfsfs",chartData)
        
        
        
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
