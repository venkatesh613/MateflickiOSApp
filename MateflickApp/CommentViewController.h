//
//  CommentViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 27/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "AppDelegate.h"

@interface CommentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SINCallClientDelegate>
@property NSString *userNameStr;
@property NSString *fileNmaeStr;
@property NSString *profilePicStr;
@property NSString *statusStr;
@property NSString *postedDateTimeStr;
@property NSString *birthdayStr;
@property NSString *likeNoStr;
@property NSString *autoIDdStr;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *profilepic;
@property (strong, nonatomic) IBOutlet UIImageView *postedImageView;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *postedDateTime;
@property (strong, nonatomic) IBOutlet UILabel *birthday;
@property (strong, nonatomic) IBOutlet UILabel *statuslabel;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *lowerLikeBtn;

@property (strong, nonatomic) IBOutlet UITableView *lowerTableView;

@property NSMutableArray *arrData;
@property NSMutableArray *profilePicArrData;
@property NSMutableArray *firstNameArrData;
@property NSMutableArray *commentArrData;
@property NSMutableArray *dateTimeArrData;

@property (strong, nonatomic) IBOutlet UITextField *commentTextField;





@end
