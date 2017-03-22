//
//  CommentTableViewCell.h
//  MateflickApp
//
//  Created by sudheer-kumar on 27/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userProfilePicImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postedtimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;



@end
