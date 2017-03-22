//
//  ProfileViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 21/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "PostedTableViewCell.h"
#import "AFNetworking.h"
#import "CommentViewController.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchProfileData];
    [self fetchPostedData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.navigationBar.hidden = true;
    self.tabBarController.tabBar.hidden = true;
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self action:@selector(fetchProfileData) forControlEvents:UIControlEventValueChanged];
    [_refreshControl addTarget:self action:@selector(fetchPostedData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:_refreshControl];

    
    
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
    CallViewController *CVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ACVC"];
    
    CVC.call = call;
    
     [self presentViewController:CVC animated:YES completion:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    
    [self awakeFromNib];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.postedProfilePicArray.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *profile = @"profile";
    static NSString *posted = @"posted";
    
    // Space Cell
    if (indexPath.section == 0) {
        ProfileTableViewCell *cell = (ProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:profile];
       
        cell.roundView.layer.cornerRadius = cell.roundView.frame.size.width / 2;
        cell.roundView.clipsToBounds = YES;
        cell.editProfileBtn.layer.cornerRadius = cell.editProfileBtn.frame.size.width / 2;
        cell.editProfileBtn.clipsToBounds = YES;
        self.tableView.allowsSelection = NO;
        cell.userNameLabel.text = [NSString stringWithFormat:@"%@",self.firstNameArray[indexPath.row]];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",self.birthDayInArray[indexPath.row]];
        cell.countrylabel.text = [NSString stringWithFormat:@"%@",self.countryArray[indexPath.row]];
        cell.underProfileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArray[indexPath.row]]]]];
         cell.profileImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArray[indexPath.row]]]]];
        
        return cell;
    }
    
    // Content cell
    else {
        PostedTableViewCell *cell = (PostedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:posted];
        
        if (cell == nil) {
            cell =[[PostedTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"status"];
        }
        
        if ([self.fileNameArray[indexPath.row] isEqualToString:@""]) {
            
            cell.lowerLikebtn.hidden = true;
            cell.lowerCommentBtn.hidden = true;
            cell.lowerLikelabel.hidden = true;
            cell.lowerCommentLabel.hidden = true;
            cell.lowerFlickBtn.hidden = true;
            
            cell.postedImageView.hidden = true;
            
            cell.UpperlikeBtn.hidden = false;
            cell.likeLabel.hidden = false;
            cell.upperCammentbtn.hidden = false;
            cell.upperCommentLabel.hidden = false;
            cell.upperFlickBtn.hidden = false;
            
        }else{
            cell.lowerLikebtn.hidden = false;
            cell.lowerCommentBtn.hidden = false;
            cell.lowerLikelabel.hidden = false;
            cell.lowerCommentLabel.hidden = false;
            cell.lowerFlickBtn.hidden = false;
            
            cell.postedImageView.hidden = false;
            
            cell.UpperlikeBtn.hidden = true;
            cell.likeLabel.hidden = true;
            cell.upperCammentbtn.hidden = true;
            cell.upperCommentLabel.hidden = true;
            cell.upperFlickBtn.hidden = true;
            
            
        }
        if ([[self.FeedStatusArray objectAtIndex:indexPath.row] isEqualToString:@"false"])
        {
            [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
            [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
            cell.lowerLikelabel.text = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexPath.row]];
            cell.likeLabel.text = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexPath.row]];
        }else{
            if (![[NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexPath.row]]isEqualToString:@"1"])
            {
                cell.lowerLikelabel.text = [NSString stringWithFormat:@"You and %@ other",self.NoOfLikesArray[indexPath.row]];
                cell.likeLabel.text = [NSString stringWithFormat:@"You and %@ other",self.NoOfLikesArray[indexPath.row]];
                [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                //.......
            }else if ([[NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexPath.row]]isEqualToString:@"1"])
            {
                cell.lowerLikelabel.text = @"You";
                cell.likeLabel.text = @"You";
                [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                
                
            }
        }
        
        // tag value for like
        cell.UpperlikeBtn.tag = indexPath.row;
        cell.lowerLikebtn.tag = indexPath.row;
        cell.postedDeleteBtn.tag = indexPath.row;
        
        [cell.UpperlikeBtn addTarget:self action:@selector(btnUpperClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lowerLikebtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //tag valus for comments
        
        
        cell.upperCammentbtn.tag = indexPath.row;
        cell.lowerCommentBtn.tag =indexPath.row;
        
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",self.dateTimeArray[indexPath.row]];
        cell.birthDayLabel.text = [NSString stringWithFormat:@"%@",self.dobArray[indexPath.row]];
        cell.lowerCommentLabel.text = [NSString stringWithFormat:@"%@",self.NoOfCommentsArray[indexPath.row]];
        cell.upperCommentLabel.text = [NSString stringWithFormat:@"%@",self.NoOfCommentsArray[indexPath.row]];
        cell.statusLabel.text = [NSString stringWithFormat:@"%@",self.textArray[indexPath.row]];
        [cell.userName setTitle:self.ownerNameNameArray[indexPath.row] forState:UIControlStateNormal];
        cell.userImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.postedProfilePicArray[indexPath.row]]]]];
        cell.postedImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.fileNameArray[indexPath.row]]]]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;

        
        return cell;
    }
}
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return 0.0f;
//    return 32.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 490;
    }else {
        if ([self.fileNameArray[indexPath.row] isEqualToString:@""]) {
            return 150;
        }else{
            return 330;
        }
    }
}
-(void)btnUpperClick:(id)sender
{
    UIButton *button=(UIButton *) sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:button.tag inSection:1];
    PostedTableViewCell *cell = (PostedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    NSString *specialistID=[NSString stringWithFormat:@"%@",self.autoIdArray[indexpath.row]];
    
    if ([cell.UpperlikeBtn.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && [cell.likeLabel.text isEqualToString: @"You"])
    {
        
        [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.likeLabel.text = @"0";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }else if ([cell.UpperlikeBtn.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && ![cell.likeLabel.text isEqualToString: @"You"]){
        [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.likeLabel.text = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexpath.row]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }
    else{
        if ([cell.UpperlikeBtn.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && [cell.likeLabel.text isEqualToString: @"0"])
        {
            
            [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.likeLabel.text = @"You";
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }else if ([cell.UpperlikeBtn.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && ![cell.likeLabel.text isEqualToString: @"0"])
        {
            [cell.UpperlikeBtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.likeLabel.text = [NSString stringWithFormat:@"You and %@ other",self.NoOfLikesArray[indexpath.row]];
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
-(void)btnClick:(id)sender
{
    UIButton *button=(UIButton *) sender;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:button.tag inSection:1];
    PostedTableViewCell *cell = (PostedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    NSString *specialistID=[NSString stringWithFormat:@"%@",self.autoIdArray[indexpath.row]];
    
    if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && [cell.lowerLikelabel.text isEqualToString: @"You"])
    {
        
        [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.lowerLikelabel.text = @"0";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=false",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            
        }
         
             failure:^(NSURLSessionTask *operation, NSError *error) {
                 NSLog(@"Error: %@", error);
             }];
        
    }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"like"]] && ![cell.lowerLikelabel.text isEqualToString: @"You"]){
        [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"love2"] forState:UIControlStateNormal];
        cell.lowerLikelabel.text = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[indexpath.row]];
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
            
            [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.lowerLikelabel.text = @"You";
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/LikeOnFeed/?accountId=%ld&feedId=%@&likeD=true",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],specialistID] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSLog(@"JSON: %@", responseObject);
                
            }
             
                 failure:^(NSURLSessionTask *operation, NSError *error) {
                     NSLog(@"Error: %@", error);
                 }];
        }else if ([button.currentBackgroundImage isEqual:[UIImage imageNamed:@"love2"]] && ![cell.lowerLikelabel.text isEqualToString: @"0"])
        {
            [cell.lowerLikebtn setBackgroundImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            cell.lowerLikelabel.text = [NSString stringWithFormat:@"You and %@ other",self.NoOfLikesArray[indexpath.row]];
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

-(IBAction)upperCommentActionBt:(UIButton *)sender {
    
    CommentViewController *CVC =[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    
    CVC.fileNmaeStr = [NSString stringWithFormat:@"%@",self.fileNameArray[sender.tag]];
    CVC.profilePicStr = [NSString stringWithFormat:@"%@",self.postedProfilePicArray[sender.tag]];
    CVC.birthdayStr = [NSString stringWithFormat:@"%@",self.dobArray[sender.tag]];
    CVC.postedDateTimeStr = [NSString stringWithFormat:@"%@",self.dateTimeArray[sender.tag]];
    CVC.likeNoStr = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[sender.tag]];
    CVC.autoIDdStr = [NSString stringWithFormat:@"%@",self.autoIdArray[sender.tag]];
    CVC.statusStr = [NSString stringWithFormat:@"%@",self.textArray[sender.tag]];
    CVC.userNameStr = [NSString stringWithFormat:@"%@",self.ownerNameNameArray[sender.tag]];
    
    
    [self.navigationController pushViewController:CVC animated:YES];
    
}
- (IBAction)lowerCommentActionBtn:(UIButton *)sender {
    
    CommentViewController *CVC =[self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
    
    CVC.fileNmaeStr = [NSString stringWithFormat:@"%@",self.fileNameArray[sender.tag]];
    CVC.profilePicStr = [NSString stringWithFormat:@"%@",self.postedProfilePicArray[sender.tag]];
    CVC.birthdayStr = [NSString stringWithFormat:@"%@",self.dobArray[sender.tag]];
    CVC.postedDateTimeStr = [NSString stringWithFormat:@"%@",self.dateTimeArray[sender.tag]];
    CVC.likeNoStr = [NSString stringWithFormat:@"%@",self.NoOfLikesArray[sender.tag]];
    CVC.autoIDdStr = [NSString stringWithFormat:@"%@",self.autoIdArray[sender.tag]];
    CVC.statusStr = [NSString stringWithFormat:@"%@",self.textArray[sender.tag]];
    CVC.userNameStr = [NSString stringWithFormat:@"%@",self.ownerNameNameArray[sender.tag]];
    
    [self.navigationController pushViewController:CVC animated:YES];
    
}


- (IBAction)editProfileBtn:(UIButton *)sender {
}
-(void)fetchProfileData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/UserProfileDetails/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        self.dataStoreArray = [[NSMutableArray alloc]init];
        self.profilePicArray = [[NSMutableArray alloc]init];
        self.firstNameArray = [[NSMutableArray alloc]init];
        self.countryArray = [[NSMutableArray alloc]init];
        self.birthDayInArray = [[NSMutableArray alloc]init];

        [self.refreshControl beginRefreshing];
        self.dataStoreArray = [responseObject valueForKey:@"UserProfileDetails"];
        for (NSDictionary *object in self.dataStoreArray) {
            NSString *firstName = object[@"firstName"];
            NSString *profilePic = object[@"profilePic"];
            NSString *country = object[@"country"];
            NSString *birthDayIn = object[@"dob"];
            
                NSString *dateTimeStr = [[NSString alloc]init];
           
                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MMM dd yyyy HH:mm:ss:SSSa";
                NSDate *yourDate = [dateFormatter dateFromString:birthDayIn];
                dateFormatter.dateFormat = @"dd MMM";
            
                dateTimeStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
            

            
            [self.profilePicArray addObject:profilePic];
            [self.firstNameArray addObject:firstName];
            [self.countryArray addObject:country];
            [self.birthDayInArray addObject:dateTimeStr];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)fetchPostedData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/AcFeeds/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
       // NSLog(@"JSON: %@", responseObject);
        
        self.postedDataStoreArray = [[NSMutableArray alloc]init];
        self.postedProfilePicArray = [[NSMutableArray alloc]init];
        self.postedNameArray = [[NSMutableArray alloc]init];
        self.autoIdArray = [[NSMutableArray alloc]init];
        self.dobArray = [[NSMutableArray alloc]init];
        self.FeedStatusArray = [[NSMutableArray alloc]init];
        self.ownerNameNameArray = [[NSMutableArray alloc]init];
        self.NoOfLikesArray = [[NSMutableArray alloc]init];
        self.NoOfCommentsArray = [[NSMutableArray alloc]init];
        self.textArray = [[NSMutableArray alloc]init];
        self.dateTimeArray = [[NSMutableArray alloc]init];
        self.PostedOnIDArray = [[NSMutableArray alloc]init];
        self.fileNameArray = [[NSMutableArray alloc]init];
        [self.refreshControl beginRefreshing];
        self.postedDataStoreArray = [responseObject valueForKey:@"AcFeeds"];
        for (NSDictionary *object in self.postedDataStoreArray) {
            NSString *autoId = object[@"autoId"];
            NSString *PostedOnID = object[@"PostedOnID"];
            NSString *postedName = object[@"postedName"];
            NSString *text = object[@"text"];
            NSString *fileName = object[@"fileName"];
            NSString *dateTime = object[@"dateTime"];
            NSString *NoOfLikes = object[@"NoOfLikes"];
            NSString *NoOfComments = object[@"NoOfComments"];
            NSString *FeedStatus = object[@"FeedStatus"];
            NSString *ownerName = object[@"ownerName"];
            NSString *dob = object[@"birthdayIn"];
            NSString *profilePic = object[@"profilePic"];
            
            // birthDay calculation
            
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MMM dd yyyy hh:mma"];
            NSDate *birthDay = [dateFormatter dateFromString:dob];
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
                BDStr = [NSString stringWithFormat:@"%ld Day's",day];
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
            
            [self.postedProfilePicArray addObject:profilePic];
            [self.postedNameArray addObject:postedName];
            [self.autoIdArray addObject:autoId];
            [self.dobArray addObject:BDStr];
            [self.FeedStatusArray addObject:FeedStatus];
            [self.ownerNameNameArray addObject:ownerName];
            [self.NoOfLikesArray addObject:NoOfLikes];
            [self.NoOfCommentsArray addObject:NoOfComments];
            [self.textArray addObject:text];
            [self.dateTimeArray addObject:dateTimeStr];
            [self.PostedOnIDArray addObject:PostedOnID];
            [self.fileNameArray addObject:fileName];


//            NSLog(@"fileNameArray=%@",self.fileNameArray);
//            NSLog(@"fileNameArray=%@",self.postedProfilePicArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (IBAction)postDeleteActionBtn:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete post" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host//DeleteContent/?accountId=%ld&feedId=%@",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"],self.autoIdArray[sender.tag]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject[@"response"][@"status"]);
            
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
                             [self fetchPostedData];
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



@end
