//WallProfileTableViewCell
//  WallStatusTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 25/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class WallStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var clickstatusBtn: UIButton!
    
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
