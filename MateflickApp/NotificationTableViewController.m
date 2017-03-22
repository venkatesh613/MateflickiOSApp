//
//  NotificationTableViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 20/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "NotificationTableViewCell.h"
#import "AFNetworking.h"

@interface NotificationTableViewController ()

@end

@implementation NotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchJsonData];
    self.navigationItem.title = @"Notification";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.hidden = false;
    self.tabBarController.tabBar.hidden = false;

    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.notificationArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *cellID = @"cell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell =[[NotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    cell.notificationUserName.text = [NSString stringWithFormat:@"%@",self.notificationArray[indexPath.row]];
    [cell.notificationUserImageBtn setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArray[indexPath.row]]]]] forState:UIControlStateNormal];
    cell.notificationUserClickedDate.text = [NSString stringWithFormat:@"%@",self.dateTimeArray[indexPath.row]];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(30, 58, 1024, 1)];
    separatorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    separatorView.layer.borderWidth = 0.8;
    [cell.contentView addSubview:separatorView];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

-(void)fetchJsonData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/NotificationPost/Default.aspx?accountid=%ld&type=1&Id=2",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.arrData = [[NSMutableArray alloc]init];
        self.dateTimeArray = [[NSMutableArray alloc]init];
        self.profilePicArray = [[NSMutableArray alloc]init];
        self.notificationArray = [[NSMutableArray alloc]init];
       
        self.arrData = [responseObject valueForKey:@"NotificationList"];
        for (NSDictionary *object in self.arrData) {
            NSString *dateTime = object[@"dateTime"];
            NSString *pic = object[@"pic"];
            NSString *notification = object[@"notification"];
            
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

            [self.notificationArray addObject:notification];
            [self.profilePicArray addObject:pic];
            [self.dateTimeArray addObject:dateTimeStr];
            
           // NSLog(@"likeArray=%@",self.notificationArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
               // [self.refreshControl endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
