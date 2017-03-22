//
//  CallsTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 08/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class CallsTableViewCell: UITableViewCell {

    @IBOutlet weak var callsUserNameLabel: UILabel!
    
    @IBOutlet weak var callsTypeLabel: UILabel!
    
    @IBOutlet weak var callsTimeLabel: UILabel!
    
    @IBOutlet weak var callsUserImageView: UIImageView!
   
    @IBOutlet weak var callsCallBtn: UIButton!
    
    @IBOutlet weak var durationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
