//
//  TabBarController.swift
//  MateFlick
//
//  Created by sudheer-kumar on 02/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    var lab = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "American Typewriter", size: 22)!], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName:UIFont(name: "American Typewriter", size: 20)!], for: .normal)
        self.tabBar.tintColor = UIColor.white
        
        UITabBar.appearance().barTintColor = UIColor.red
        
        
        //let selectedColor   = UIColor.red
        let unselectedColor = UIColor.white
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
        //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     

}
