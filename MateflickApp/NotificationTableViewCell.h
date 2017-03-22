//
//  NotificationTableViewCell.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *notificationUserImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *notificationUserName;
@property (weak, nonatomic) IBOutlet UILabel *notificationUserClickedDate;

@end
