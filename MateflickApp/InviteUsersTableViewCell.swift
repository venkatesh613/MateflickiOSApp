//
//  InviteUsersTableViewCell.swift
//  MateflickApp
//
//  Created by Safiqul Islam on 21/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit


class InviteUsersTableViewCell: UITableViewCell {

    @IBOutlet weak var invite: UIButton!
    @IBOutlet weak var mobile: UILabel!
    @IBOutlet weak var nameText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
