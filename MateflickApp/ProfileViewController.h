//
//  ProfileViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 21/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "AppDelegate.h"


@interface ProfileViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SINCallClientDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UIRefreshControl *refreshControl;
//Profile
@property NSMutableArray *dataStoreArray;
@property NSMutableArray *profilePicArray;
@property NSMutableArray *firstNameArray;
@property NSMutableArray *countryArray;
@property NSMutableArray *birthDayInArray;
//Posted
@property NSMutableArray *postedDataStoreArray;
@property NSMutableArray *postedProfilePicArray;
@property NSMutableArray *postedNameArray;
@property NSMutableArray *autoIdArray;
@property NSMutableArray *dobArray;
@property NSMutableArray *FeedStatusArray;
@property NSMutableArray *ownerNameNameArray;
@property NSMutableArray *NoOfLikesArray;
@property NSMutableArray *NoOfCommentsArray;
@property NSMutableArray *textArray;
@property NSMutableArray *dateTimeArray;
@property NSMutableArray *PostedOnIDArray;
@property NSMutableArray *fileNameArray;



@end
