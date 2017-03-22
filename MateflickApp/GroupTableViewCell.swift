//
//  GroupTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 08/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    
    @IBOutlet weak var groupUserImageBtn: UIButton!
    
    @IBOutlet weak var groupusernamelabel: UILabel!
    
    @IBOutlet weak var groupChatBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
