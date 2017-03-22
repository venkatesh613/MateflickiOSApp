//
//  WallPostedTableViewCell.swift
//  MateflickApp
//
//  Created by sudheer-kumar on 25/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

import UIKit

class WallPostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameBtn: UIButton!
    
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    @IBOutlet weak var birthDayLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var postDeleteBtn: UIButton!
    
    @IBOutlet weak var upperLikeBtn: UIButton!

    @IBOutlet weak var upperLikelabel: UILabel!
    
    @IBOutlet weak var upperCommentBtn: UIButton!
    
    @IBOutlet weak var upperCommentLabel: UILabel!
    
    @IBOutlet weak var upperFlickBtn: UIButton!
    
    @IBOutlet weak var postedImageView: UIImageView!
    
    @IBOutlet weak var lowerLikeBtn: UIButton!
    
    @IBOutlet weak var lowerLikeLabel: UILabel!
    
    @IBOutlet weak var lowerCommentBtn: UIButton!
    
    @IBOutlet weak var lowerCommentLabel: UILabel!
    
    @IBOutlet weak var lowerFlickBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
