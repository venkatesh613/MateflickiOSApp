//
//  CommentViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 27/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentUserDetailsTableViewCell.h"
#import "AFNetworking.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchJsonData];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.lowerTableView.delegate = self;
    self.lowerTableView.dataSource = self;
   
    self.username.text = self.userNameStr;
    self.postedDateTime.text = self.postedDateTimeStr;
    self.statuslabel.text = self.statusStr;
    self.birthday.text = self.birthdayStr;
    self.profilepic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicStr]]]];
    self.postedImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.fileNmaeStr]]]];
    self.tabBarController.tabBar.hidden = true;
    self.navigationController.navigationBar.hidden = false;
    
    if ([self.fileNmaeStr isEqualToString:@""])
    {
        self.postedImageView.hidden = true;
        self.lowerLikeBtn.hidden = true;
        self.likeBtn.hidden = false;
        self.tableView.hidden = false;
        self.lowerTableView.hidden = true;
        
        
    }else{
        self.postedImageView.hidden = false;
        self.lowerLikeBtn.hidden = false;
        self.likeBtn.hidden = true;
        self.tableView.hidden = true;
        self.lowerTableView.hidden = false;
        
        

    }
    [self.commentTextField becomeFirstResponder];
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
    if (tableView == self.tableView)
    {
        return 1;
    }
    
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView)
    {
        return self.firstNameArrData.count;
    }
    
    else
    {
        return self.firstNameArrData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _tableView) {
    
        static NSString *CellIdentifier = @"comment";
        CommentUserDetailsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CommentUserDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:CellIdentifier];
        }
        
        cell.profilePicImageView.layer.cornerRadius = cell.profilePicImageView.frame.size.width / 2;
        cell.profilePicImageView.clipsToBounds = YES;
        cell.profilePicImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArrData[indexPath.row]]]]];
        cell.userName.text = [NSString stringWithFormat:@"%@",self.firstNameArrData[indexPath.row]];
        cell.postedtimeLabel.text = [NSString stringWithFormat:@"%@",self.dateTimeArrData[indexPath.row]];
        cell.commentLabel.text = [NSString stringWithFormat:@"%@",self.commentArrData[indexPath.row]];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        self.tableView.allowsSelection = NO;
        
        return cell;
    }
     else  {
         
        static NSString *CellIdentifier = @"cell";
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:CellIdentifier];
        }

         cell.userProfilePicImageView.layer.cornerRadius = cell.userProfilePicImageView.frame.size.width / 2;
         cell.userProfilePicImageView.clipsToBounds = YES;
         cell.userProfilePicImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArrData[indexPath.row]]]]];
         cell.usernameLabel.text = [NSString stringWithFormat:@"%@",self.firstNameArrData[indexPath.row]];
         cell.postedtimeLabel.text = [NSString stringWithFormat:@"%@",self.dateTimeArrData[indexPath.row]];
         cell.commentLabel.text = [NSString stringWithFormat:@"%@",self.commentArrData[indexPath.row]];
         self.lowerTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
         self.lowerTableView.allowsSelection = NO;

        return cell;
    }

 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
    
}
-(void)fetchJsonData{
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/CommentList/?feedId=%@",self.autoIDdStr] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON1: %@", responseObject);
        
       // NSLog(@"id %@",self.autoIDdStr);
        self.arrData =[[NSMutableArray alloc]init];
        self.profilePicArrData =[[NSMutableArray alloc]init];
        self.firstNameArrData =[[NSMutableArray alloc]init];
        self.commentArrData =[[NSMutableArray alloc]init];
        self.dateTimeArrData =[[NSMutableArray alloc]init];
        self.arrData = [responseObject valueForKey:@"CommentList"];
        
        NSLog(@"%@",self.arrData);
        for (NSDictionary *object in self.arrData) {
            
            NSString *profilePic = object[@"profilePic"];
            NSString *firstName = object[@"firstName"];
            NSString *comment = object[@"comment"];
            NSString *dateTime = object[@"dateTime"];
           

              //posted time
            NSDate *today = [NSDate date];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MMM dd yyyy HH:mm:ss:SSSa"];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            NSDate *postedTime = [dateFormatter dateFromString:dateTime];
            //[dateFormatter setDateFormat:@"MMM dd yyyy HH:mm:ss:SSSa"];
            
            NSCalendar *Calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDateComponents *components = [Calendar components:NSCalendarUnitSecond
                                                         fromDate:postedTime
                                                           toDate:today
                                                          options:0];
            NSString *dateTimeStr = [[NSString alloc]init];
            NSInteger  sec = components.second;
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
            
            
            
            [self.firstNameArrData addObject:firstName];
            [self.commentArrData addObject:comment];
            [self.dateTimeArrData addObject:dateTimeStr];
            [self.profilePicArrData addObject:profilePic];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.lowerTableView reloadData];
                [self.tableView reloadData];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
- (IBAction)commentactionBtn:(UIButton *)sender {
    
    NSDictionary *parameter = @{@"feedId":self.autoIDdStr,@"comment":self.commentTextField.text,@"accountId":[NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]]};
   
    NSString *URLString = @"http://api.mateflick.host/CommentOnFeed/Default.aspx?";
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.commentTextField.text = NULL;
                [self fetchJsonData];
                
                
                
            });
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSLog(@"Response == %@",responseObject);
                
               
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        
    }]resume];


 
}

@end
