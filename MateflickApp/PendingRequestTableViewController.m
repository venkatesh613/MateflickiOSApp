//
//  PendingRequestTableViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 20/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "PendingRequestTableViewController.h"
#import "PendingrequestTableViewCell.h"
#import "AFNetworking.h"

@interface PendingRequestTableViewController ()

@end

@implementation PendingRequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchJsonData];
    self.navigationItem.title = @"Pending Request";
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

    return self.firstNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    PendingrequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (cell == nil) {
        cell =[[PendingrequestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.userNamelabel.text = [NSString stringWithFormat:@"%@",self.firstNameArray[indexPath.row]];
    cell.userImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.profilePicArray[indexPath.row]]]]];
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(30, 58, 1024, 1)];
    separatorView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    separatorView.layer.borderWidth = 0.8;
    [cell.contentView addSubview:separatorView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)fetchJsonData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/FriendPendingrequest/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        self.dataStoreArray = [[NSMutableArray alloc]init];
        self.profilePicArray = [[NSMutableArray alloc]init];
        self.firstNameArray = [[NSMutableArray alloc]init];
        
        self.dataStoreArray = [responseObject valueForKey:@"Pendingfriendslist"];
        for (NSDictionary *object in self.dataStoreArray) {
            NSString *firstName = object[@"firstName"];
            NSString *profilePic = object[@"profilePic"];
            
            [self.profilePicArray addObject:profilePic];
            [self.firstNameArray addObject:firstName];
            
            //NSLog(@"likeArray=%@",self.firstNameArray);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // [self.refreshControl endRefreshing];
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
