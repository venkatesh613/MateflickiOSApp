//
//  PostedTableViewCell.h
//  MateflickApp
//
//  Created by sudheer-kumar on 21/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UIButton *postedDeleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *UpperlikeBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIButton *upperCammentbtn;
@property (weak, nonatomic) IBOutlet UILabel *upperCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *upperFlickBtn;
@property (weak, nonatomic) IBOutlet UIImageView *postedImageView;
@property (weak, nonatomic) IBOutlet UIButton *lowerLikebtn;
@property (weak, nonatomic) IBOutlet UILabel *lowerLikelabel;
@property (weak, nonatomic) IBOutlet UIButton *lowerCommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *lowerCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *lowerFlickBtn;












@end
