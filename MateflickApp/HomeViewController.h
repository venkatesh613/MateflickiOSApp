//
//  HomeViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

@interface HomeViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,SINCallClientDelegate,SINCallDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *ownerPic;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *fileNameArray;
@property NSMutableArray * profilePicArray;
@property NSMutableArray *userNameArray;
@property NSMutableArray * ownerNameArray;
@property NSMutableArray *ownerTypeArray;
@property NSMutableArray *PostedOnArray;
@property NSMutableArray *PostedOnIDArray;
@property NSMutableArray *postedNameArray;
@property NSMutableArray *contentTypeArray;
@property NSMutableArray *statusArray;
@property NSMutableArray * likeArray;
@property NSMutableArray * commentArray;
@property NSMutableArray * birthDayArray;
@property NSMutableArray * postedDateTimeArray;
@property NSMutableArray * autoIDArray;
@property NSMutableArray *arrData;
@property NSMutableArray *profPic;
@property NSMutableArray *FeedStatusArray;
@property NSMutableArray *ownerIdArray;
@property UIActivityIndicatorView *activityView;
@property (nonatomic, assign) BOOL iconClick;
@property UIRefreshControl *refreshControl;
@property NSString *specialStr;
@property NSString *ownerPicStr;

@property (nonatomic, assign) BOOL isScrolling;

@property NSMutableDictionary *jsonDic;
@property NSString *userProfilePicStr;
@property NSMutableArray *userDataStoreArray;


@end
