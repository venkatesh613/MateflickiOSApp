//
//  WallACProfileTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 25/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class WallACProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var underImageView: UIImageView!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var roundView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userDOBLabel: UILabel!
    
    @IBOutlet weak var userCountryLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var mutualfriendsLabel: UILabel!
    
    @IBOutlet weak var friendslabel: UILabel!
    
    @IBOutlet weak var postLable: UILabel!
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
