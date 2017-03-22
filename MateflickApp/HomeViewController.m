//
//  HomeViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 20/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "HomeViewController.h"
#import "AFNetworking.h"
#import "HomeTableViewCell.h"
#import "MindOnTableViewCell.h"
#import "HomeCollectionTableViewCell.h"
#import "CollectionViewCell.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "MateflickApp-Swift.h"
#import "ProfileViewController.h"





@interface HomeViewController ()

@end

@implementation HomeViewController
{
    NSMutableArray *array;
    NSString *image;
    NSString *name;
    AppDelegate *app;
    NSMutableArray *array2;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchProfileData];
    [self fetchJsonData];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    self.activityView = [[UIActivityIndicatorView alloc]
                         initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityView.backgroundColor = [UIColor redColor];
    self.activityView.tintColor = [UIColor redColor];
    self.activityView.center = CGPointMake( [UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [app.window addSubview:self.activityView];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self action:@selector(fetchJsonData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight =  UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchProfileData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/UserProfileDetails/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        self.userDataStoreArray = [[NSMutableArray alloc]init];
        self.userProfilePicStr = [[NSString alloc]init];
        
        self.userDataStoreArray = [responseObject valueForKey:@"UserProfileDetails"];
        for (NSDictionary *object in self.userDataStoreArray) {
            
            self.userProfilePicStr = object[@"profilePic"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.userProfilePicStr  isEqualToString: @""]) {
                    
                }else{
                    self.ownerPic.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userProfilePicStr]]]];
                }
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
//CollectionView...........
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 30;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    return cell;
}
-(void) viewWillAppear: (BOOL) animated {
    
    self.tabBarController.tabBar.hidden = false;
    self.navigationController.navigationBar.hidden = false;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else {
        return self.ownerNameArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mindID = @"mind";
    static NSString *collectionID = @"collection";
    static NSString *statusID = @"status";
    
    if (indexPath.section == 0) {
        
        MindOnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mindID forIndexPath:indexPath];
        if (cell == nil) {
            cell =[[MindOnTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mind"];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        
        HomeCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:collectionID forIndexPath:indexPath];
        if (cell == nil) {
            cell =[[HomeCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"collection"];
        }
        return cell;
        
    }else{
        
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:statusID forIndexPath:indexPath];
        
        if (cell == nil) {
            cell =[[HomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
        }
        
        if ([self.fileNameArray[indexPath.row] isEqualToString:@""]) {
            
            cell.likeButton.hidden = true;
            cell.commentButton.hidden = true;
            cell.likeLabel.hidden = true;
            cell.commentLabel.hidden = true;
            cell.lowerFlickBtn.hidden = true;
            
            cell.postedImage.hidden = true;
            
            cell.upperLabel.hidden = false;
            cell.upperLikeB.hidden = false;
            cell.upperCommentB.hidden = false;
            cell.uppercommentlabel.hidden = false;
            cell.upperFlickBtn.hidden = false;
            
        }else{
            cell.likeButton.hidden = false;
            cell.commentButton.hidden = false;
            cell.likeLabel.hidden = false;
            cell.commentLabel.hidden = false;
            cell.lowerFlickBtn.hidden = false;
            
            cell.postedImage.hidden = false;
            
            cell.upperLabel.hidden = true;
            cell.upperLikeB.hidden = true;
            cell.upperCommentB.hidden = true;
            cell.uppercommentlabel.hidden = true;
            cell.upperFlickBtn.hidden = true;
            
            
        }
        
        
        if ([[self.FeedStatusArray objectAtIndex:indexPath.row] isEqualToString:@"false"])
        {
            
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
            [cell.upperLikeB setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
            cell.likeLabel.text = [NSString stringWithFormat:@"%@",self.likeArray[indexPath.row]];
            cell.upperLabel.text = [NSString stringWithFormat:@"%@",self.likeArray[indexPath.row]];
        }else{
            if (![[NSString stringWithFormat:@"%@",self.likeArray[indexPath.row]]isEqualToString:@"1"])
            {
                
                cell.likeLabel.text = [NSString stringWithFormat:@"You and %@ other",self.likeArray[indexPath.row]];
                cell.upperLabel.text = [NSString stringWithFormat:@"You and %@ other",self.likeArray[indexPath.row]];
                
                
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [cell.upperLikeB setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                
            }else if ([[NSString stringWithFormat:@"%@",self.likeArray[indexPath.row]]isEqualToString:@"1"])
            {
                cell.likeLabel.text = @"You";
                cell.upperLabel.text = @"You";
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [cell.upperLikeB setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                
                
            }
        }
        
        // tag value for like
        cell.upperLikeB.tag = indexPath.row;
        cell.likeButton.tag = indexPath.row;
        cell.postDeleteBtn.tag = indexPath.row;
        cell.userNameBtn.tag = indexPath.row;
        
        [cell.upperLikeB addTarget:self action:@selector(btnUpperClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.likeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //tag valus for comments
        
        
        cell.upperCommentB.tag = indexPath.row;
        cell.commentButton.tag =indexPath.row;
        
        cell.hourLabel.text = [NSString stringWithFormat:@"%@",self.postedDateTimeArray[indexPath.row]];
        cell.birthDaylabel.text = [NSString stringWithFormat:@"%@",self.birthDayArray[indexPath.row]];
        cell.commentLabel.text = [NSString stringWithFormat:@"%@",self.commentArray[indexPath.row]];
        cell.uppercommentlabel.text = [NSString stringWithFormat:@"%@",self.commentArray[indexPath.row]];
        cell.statusLabel.text = self.statusArray[indexPath.row];
        [cell.userNameBtn setTitle:self.ownerNameArray[indexPath.row] forState:UIControlStateNormal];
        //cell.profilePic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArray[indexPath.row]]]]];
        //cell.postedImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.fileNameArray[indexPath.row]]]]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        self.tableView.allowsSelection = NO;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        // [self.activityView stopAnimating];
        
        return cell;
    }
}
-(void)btnUpperClick:(id)sender
{
    UIButton *button=(UIButton *) sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:button.tag inSection:2];
    HomeTableViewCell *cell = (HomeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    NSString *specialistID=[NSString stringWithFormat:@"%@",self.autoIDArray[indexpath.row]];
    
    
    if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && [cell.upperLabel.text isEqualToString: @"You"])
    {
        
        [button setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.upperLabel.text = @"0";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && ![cell.upperLabel.text isEqualToString: @"You"]){
        [button setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.upperLabel.text = [NSString stringWithFormat:@"%@",self.likeArray[indexpath.row]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }
    else{
        if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && [cell.upperLabel.text isEqualToString: @"0"])
        {
            
            [button setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.upperLabel.text = @"You";
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && ![cell.upperLabel.text isEqualToString: @"0"])
        {
            [button setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.upperLabel.text = [NSString stringWithFormat:@"You and %@ other",self.likeArray[indexpath.row]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }
        
    }
    //[cell.contentView setUserInteractionEnabled: NO];
}
-(void)btnClick:(id)sender
{
    UIButton *button=(UIButton *) sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:button.tag inSection:2];
    HomeTableViewCell *cell = (HomeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    NSString *specialistID=[NSString stringWithFormat:@"%@",self.autoIDArray[indexpath.row]];
    
    
    if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && [cell.likeLabel.text isEqualToString: @"You"])
    {
        
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.likeLabel.text = @"0";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && ![cell.likeLabel.text isEqualToString: @"You"]){
        [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.likeLabel.text = [NSString stringWithFormat:@"%@",self.likeArray[indexpath.row]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }
    else{
        if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && [cell.likeLabel.text isEqualToString: @"0"])
        {
            
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.likeLabel.text = @"You";
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && ![cell.likeLabel.text isEqualToString: @"0"])
        {
            [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.likeLabel.text = [NSString stringWithFormat:@"You and %@ other",self.likeArray[indexpath.row]];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1) {
        return 170;
    }else{
        if ([self.fileNameArray[indexPath.row] isEqualToString:@""]) {
            return 133;
        }
        
        return 325;
    }
}

-(void)fetchJsonData{
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/AcWallFeedsAccount/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.arrData = [[NSMutableArray alloc]init];
        self.fileNameArray = [[NSMutableArray alloc]init];
        self.profilePicArray = [[NSMutableArray alloc]init];
        self.ownerNameArray = [[NSMutableArray alloc]init];
        self.likeArray = [[NSMutableArray alloc]init];
        self.commentArray = [[NSMutableArray alloc]init];
        self.statusArray = [[NSMutableArray alloc]init];
        self.birthDayArray = [[NSMutableArray alloc]init];
        self.postedDateTimeArray = [[NSMutableArray alloc]init];
        self.autoIDArray = [[NSMutableArray alloc]init];
        self.FeedStatusArray =[[NSMutableArray alloc]init];
        self.ownerIdArray =[[NSMutableArray alloc]init];
        self.contentTypeArray=[[NSMutableArray alloc]init];
        self.postedNameArray=[[NSMutableArray alloc]init];
        self.PostedOnIDArray=[[NSMutableArray alloc]init];
        self.PostedOnArray=[[NSMutableArray alloc]init];
        self.ownerTypeArray=[[NSMutableArray alloc]init];
        self.contentTypeArray=[[NSMutableArray alloc]init];
        [self.refreshControl beginRefreshing];
        //[self.activityView startAnimating];
        self.arrData = [responseObject valueForKey:@"AcFeeds"];
        for (NSDictionary *object in self.arrData) {
            NSString *objectName = object[@"fileName"];
            NSString *objectType = object[@"profilePic"];
            NSString *username = object[@"ownerName"];
            NSString *likeNo = object[@"NoOfLikes"];
            NSString *commentNo = object[@"NoOfComments"];
            NSString *text = object[@"text"];
            NSString *birthday = object[@"birthdayIn"];
            NSString *dateTime = object[@"dateTime"];
            NSString *autoId = object[@"autoId"];
            NSString *FeedStatus = object[@"FeedStatus"];
            NSString *ownerId = object[@"ownerId"];
            
            // birthDay calculation
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MMM dd yyyy hh:mma"];
            NSDate *birthDay = [dateFormatter dateFromString:birthday];
            [dateFormatter setDateFormat:@"MMM dd yyyy hh:mma"];
            NSDate *todayDate = [NSDate date]; //Get todays date
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *year = [[NSDateComponents alloc] init];
            NSInteger yearDiff = 1;
            NSDate *newBirthday = birthDay;
            while([newBirthday earlierDate:todayDate] == newBirthday) {
                [year setYear:yearDiff++];
                newBirthday = [gregorianCalendar dateByAddingComponents:year toDate:birthDay options:0];
            }
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:todayDate
                                                                  toDate:newBirthday
                                                                 options:0];
            
            NSInteger  day = components.day;
            NSString *BDStr = [[NSString alloc]init];
            if (day==364) {
                BDStr = @"Today";
            }else{
                BDStr = [NSString stringWithFormat:@"%ld Days",day];
            }
            
            //posted time
            
            NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc]init];
            [dateFormatter2 setDateFormat:@"MMM dd yyyy HH:mm:ss:SSSa"];
            NSDate *postedTime = [dateFormatter2 dateFromString:dateTime];
            [dateFormatter2 setDateFormat:@"MMM dd yyyy HH:mm:ss:SSSa"];
            NSDate *today = [NSDate date];
            [dateFormatter2 setTimeZone:[NSTimeZone systemTimeZone]];
            
            
            NSCalendar *Calendar2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *components2 = [Calendar2 components:NSCalendarUnitSecond
                                                         fromDate:postedTime
                                                           toDate:today
                                                          options:0];
            NSString *dateTimeStr = [[NSString alloc]init];
            NSInteger  sec = components2.second;
            NSInteger  min  = sec / 60;
            NSInteger hour = sec / 3600;
            if (sec<60) {
                dateTimeStr = [NSString stringWithFormat:@"%ldS",sec];
            }else if (min<60){
                dateTimeStr = [NSString stringWithFormat:@"%ldM",min];
            }else if (hour<12){
                dateTimeStr = [NSString stringWithFormat:@"%ldH",hour];
            }else if (hour<24){
                dateTimeStr = @"Today";
            }else if (hour<48){
                dateTimeStr = @"Yesterday";
            }else{
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MMM dd yyyy HH:mm:ss:SSSa";
                NSDate *yourDate = [dateFormatter dateFromString:dateTime];
                dateFormatter.dateFormat = @"dd MMM yyyy";
                dateTimeStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
            }
            
            [self.fileNameArray addObject:objectName];
            [self.profilePicArray addObject:objectType];
            [self.ownerNameArray addObject:username];
            [self.likeArray addObject:likeNo];
            [self.commentArray addObject:commentNo];
            [self.statusArray addObject:text];
            [self.birthDayArray addObject:BDStr];
            [self.postedDateTimeArray addObject:dateTimeStr];
            [self.autoIDArray addObject:autoId];
            [self.FeedStatusArray addObject:FeedStatus];
            [self.ownerIdArray addObject:ownerId];
            //NSLog(@"likeArray=%@",self.likeArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (IBAction)upperCommentActionBt:(UIButton *)sender {
    
    CommentViewController *CVC =[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    
    CVC.fileNmaeStr = [NSString stringWithFormat:@"%@",self.fileNameArray[sender.tag]];
    CVC.profilePicStr = [NSString stringWithFormat:@"%@",self.profilePicArray[sender.tag]];
    CVC.birthdayStr = [NSString stringWithFormat:@"%@",self.birthDayArray[sender.tag]];
    CVC.postedDateTimeStr = [NSString stringWithFormat:@"%@",self.postedDateTimeArray[sender.tag]];
    CVC.likeNoStr = [NSString stringWithFormat:@"%@",self.likeArray[sender.tag]];
    CVC.autoIDdStr = [NSString stringWithFormat:@"%@",self.autoIDArray[sender.tag]];
    CVC.statusStr = [NSString stringWithFormat:@"%@",self.statusArray[sender.tag]];
    CVC.userNameStr = [NSString stringWithFormat:@"%@",self.ownerNameArray[sender.tag]];
    
    [self.navigationController pushViewController:CVC animated:YES];
    
}
- (IBAction)lowerCommentActionBtn:(UIButton *)sender {
    
    CommentViewController *CVC =[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    
    CVC.fileNmaeStr = [NSString stringWithFormat:@"%@",self.fileNameArray[sender.tag]];
    CVC.profilePicStr = [NSString stringWithFormat:@"%@",self.profilePicArray[sender.tag]];
    CVC.birthdayStr = [NSString stringWithFormat:@"%@",self.birthDayArray[sender.tag]];
    CVC.postedDateTimeStr = [NSString stringWithFormat:@"%@",self.postedDateTimeArray[sender.tag]];
    CVC.likeNoStr = [NSString stringWithFormat:@"%@",self.likeArray[sender.tag]];
    CVC.autoIDdStr = [NSString stringWithFormat:@"%@",self.autoIDArray[sender.tag]];
    CVC.statusStr = [NSString stringWithFormat:@"%@",self.statusArray[sender.tag]];
    CVC.userNameStr = [NSString stringWithFormat:@"%@",self.ownerNameArray[sender.tag]];
    
    [self.navigationController pushViewController:CVC animated:YES];
    
}
- (IBAction)postDeleteActionBtn:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete post" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host//DeleteContent/?accountId=%ld&feedId=%@",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],self.autoIDArray[sender.tag]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject[@"response"][@"status"]);
            
            //[alertController dismissViewControllerAnimated:YES completion:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                //[self.refreshControl endRefreshing];
                if ([responseObject[@"response"][@"status"] isEqualToString:@"success"]) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Post delete successfully" preferredStyle:UIAlertControllerStyleAlert];
                    
                    alertController.view.tintColor = [UIColor redColor];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [alertController dismissViewControllerAnimated:YES completion:^{
                            // do something ?
                            [self fetchJsonData];
                        }];
                        
                    });
                }else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Failed to delete post" preferredStyle:UIAlertControllerStyleAlert];
                    alertController.view.tintColor = [UIColor redColor];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [alertController dismissViewControllerAnimated:YES completion:^{
                            // do something ?
                        }];
                        
                    });
                }
                
            });
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }]];
    
    alertController.view.tintColor = [UIColor redColor];
    [self presentViewController:alertController animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:^{
            // do something ?
        }];
        
    });
    
}
- (IBAction)upperFlickActionBtn:(UIButton *)sender {
    
    
}
- (IBAction)lowerFlickActionBtn:(UIButton *)sender {
    
    
}
- (IBAction)userNameActionBtn:(UIButton *)sender {
    if ([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",self.ownerIdArray[sender.tag]]] ) {
        
        ProfileViewController *PVC =[self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        [self.navigationController pushViewController:PVC animated:YES];
        
    }else{
        
        WallACFeedsViewController *WACFVC =[self.storyboard instantiateViewControllerWithIdentifier:@"wallProfile"];
        WACFVC.IDStr = [NSString stringWithFormat:@"%@",self.ownerIdArray[sender.tag]];
        [self.navigationController pushViewController:WACFVC animated:YES];
        
    }
    
}
- (id<SINClient>)client {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.client.callClient.delegate = self;
    

}
-(void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
    
    if([call.details isVideoOffered])
    {
        VideoCallViewController *VCC = [self.storyboard instantiateViewControllerWithIdentifier:@"Video"];
        
        VCC.call = call;
        [self presentViewController:VCC animated:YES completion:nil];
        
    }
    else
    {
    
        CallViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ACVC"];
        
        CVC.call = call;
        
        [self presentViewController:CVC animated:YES completion:nil];
    
    }
        
    
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self awakeFromNib];
    
}




@end
