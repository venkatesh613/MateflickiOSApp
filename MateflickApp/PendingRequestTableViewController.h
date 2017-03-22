//
//  PendingRequestTableViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Sinch/Sinch.h>

@interface PendingRequestTableViewController : UITableViewController<SINCallClientDelegate>
@property NSMutableArray *dataStoreArray;
@property NSMutableArray *profilePicArray;
@property NSMutableArray *firstNameArray;
@end
