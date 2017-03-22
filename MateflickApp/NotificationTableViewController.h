//
//  NotificationTableViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Sinch/Sinch.h>

@interface NotificationTableViewController : UITableViewController<SINCallClientDelegate>
@property NSMutableArray * dateTimeArray;
@property NSMutableArray *arrData;
@property NSMutableArray *profilePicArray;
@property NSMutableArray *notificationArray;

@end
