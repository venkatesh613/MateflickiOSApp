//
//  ConnectsTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 08/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class ConnectsTableViewCell: UITableViewCell {

    @IBOutlet weak var connectsUserImage: UIImageView!
    
    @IBOutlet weak var connectsUserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
