//
//  BDayMateViewController.m
//  MateflickApp
//
//  Created by Safiqul Islam on 01/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "BDayMateViewController.h"
#import "ProfileViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <AFNetworking/AFNetworking.h>
#import "MateflickApp-Swift.h"

NSString *latitude;
NSString *longtitude;
UILabel *locationlabel;
GMSMarker *markerAlways;

int j;
@interface BDayMateViewController ()
@property (weak, nonatomic) IBOutlet UIView *navigateLabel;
@property  NSMutableDictionary *accountID;
@property NSMutableArray *accountArray;
@property GMSMarker *marker;
@property GMSMarker *marker1;
@property GMSMapView *mapView;
@property NSString *UIDeviceString;
@property NSMutableArray *updateLat;
@property NSMutableArray *updateLong;
@property NSDictionary *parameter;



@end

@implementation BDayMateViewController
{
   // GMSPlacesClient *_placesClient;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.UIDeviceString = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", self.UIDeviceString);
    
    

    
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = false;
    
    
}

- (IBAction)enableBtn:(id)sender {
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    //getting latitude and logtitude for current location of User
    latitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude];
    longtitude = [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitude floatValue]
                                                            longitude:[longtitude floatValue]
                                                                 zoom:3];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.padding = UIEdgeInsetsMake(0, 0, 30, 15);
    
   // self.mapView.settings.
    
     CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake(self.mapView.camera.target.latitude,self.mapView.camera.target.longitude);
    
    markerAlways = [GMSMarker markerWithPosition:position1];
    markerAlways.title = @"No";
    
   // [markerAlways setDraggable:YES];
    
   // [self.mapView addSubview:markerAlways.map];
    
    markerAlways.map = self.mapView;

    
    

    self.view = _mapView;
    
    [_mapView addSubview:_navigateLabel];
    locationlabel = [[UILabel alloc]init];
    locationlabel.frame = CGRectMake(10, 600, 350, 30);
    locationlabel.text = @"Sorry We dont have user on this location yet";
    locationlabel.textColor = [UIColor redColor];
    locationlabel.backgroundColor = [UIColor whiteColor];
    locationlabel.hidden = YES;
    [self.mapView addSubview:locationlabel];
    

   
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/BDayMates/?accountId=%@&latCode=%@&&LongCode=%@",@"2400007",@"21.2504743",@"81.6682245"]
      parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         self.lattitudes = [[NSMutableArray alloc]init];
         self.longtitudes = [[NSMutableArray alloc] init];
         self.profilePicArray = [[NSMutableArray alloc] init];
         self.dataArray = [[NSMutableArray alloc] init];
         self.nameArray = [[NSMutableArray alloc] init];
         self.accountArray = [[NSMutableArray alloc] init];
         
         self.dataArray = [responseObject objectForKey:@"UserAccountGPSLocation"];
         
         NSLog(@"%@",self.dataArray);
         
         for (NSDictionary *object in self.dataArray)
         {
             NSString *lat = object[@"lat"];
             NSString *longt = object[@"long"];
             NSString *proPic = object[@"profilePic"];
             NSString *name = object[@"name"];
             NSString *accountID = object[@"accountId"];
             
             
             
             [self.lattitudes addObject:lat];
             [self.longtitudes addObject:longt];
             [self.profilePicArray addObject:proPic];
             [self.nameArray addObject:name];
             [self.accountArray addObject:accountID];
             
         }
         self.accountID = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.nameArray,self.accountArray, nil];
         NSLog(@"%@",self.accountID);
         NSLog(@"%@",self.lattitudes);
         NSLog(@"%@",self.longtitudes);
         NSLog(@"%@",self.profilePicArray);
         
         for (int i=0;i<=self.lattitudes.count-1; i++)
         {
             
             CLLocationCoordinate2D position = CLLocationCoordinate2DMake([[self.lattitudes objectAtIndex:i] floatValue],[[self.longtitudes objectAtIndex:i] floatValue]);
             
             self.marker = [GMSMarker markerWithPosition:position];
             self.marker.title = [self.accountArray objectAtIndex:i];
             self.marker.snippet = @"MetFlick";
             
             
             
             NSLog(@"marker title %@",_marker.title);
             
             _marker.map = _mapView;
             if ([[NSString stringWithFormat:@"%@",[self.profilePicArray objectAtIndex:i]]isEqualToString:@""]) {
                 UIImage *image = [UIImage imageNamed:@"profile"];
                 NSData *data = [[NSData alloc] init];
                 data = UIImagePNGRepresentation(image);
                 _marker.icon = [UIImage imageWithData:data scale:5.0];
             }
             else{
                 _marker.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.profilePicArray objectAtIndex:i]]]] scale:18.0];
                 
                 _marker.map = _mapView;
             }
             
         }
         
     }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

    
     //[NSTimer scheduledTimerWithTimeInterval:100.0f target:self selector:@selector(gettingData) userInfo:nil repeats:YES];
   
   
}



- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
      markerAlways.position = self.mapView.camera.target;
    
        [self.mapView clear];
    
        GMSMarker *marker = [[GMSMarker alloc] init];
     CLLocationCoordinate2D position1 = CLLocationCoordinate2DMake(mapView.camera.target.latitude,mapView.camera.target.longitude);
       marker.position =position1;
    
    
         marker.title = @"No";
        marker.map = self.mapView;
    
    
    
    //markerAlways.appearAnimation = kGMSMarkerAnimationPop;
    
    NSLog(@"camera.target.latitude %f,%f",mapView.camera.target.latitude,mapView.camera.target.longitude);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
      
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/BDayMates/?accountId=%@&latCode=%f&&LongCode=%f",@"2400007",self.mapView.camera.target.latitude,mapView.camera.target.longitude]
      parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         
         self.lattitudes = [[NSMutableArray alloc]init];
         self.longtitudes = [[NSMutableArray alloc] init];
         self.profilePicArray = [[NSMutableArray alloc] init];
         self.dataArray = [[NSMutableArray alloc] init];
         self.nameArray = [[NSMutableArray alloc] init];
         self.accountArray = [[NSMutableArray alloc] init];
         
         self.dataArray = [responseObject objectForKey:@"UserAccountGPSLocation"];
         
         NSLog(@"%@",self.dataArray);
         
         for (NSDictionary *object in self.dataArray)
         {
             NSString *lat = object[@"lat"];
             NSString *longt = object[@"long"];
             NSString *proPic = object[@"profilePic"];
             NSString *name = object[@"name"];
             NSString *accountID = object[@"accountId"];
             
             
             
             [self.lattitudes addObject:lat];
             [self.longtitudes addObject:longt];
             [self.profilePicArray addObject:proPic];
             [self.nameArray addObject:name];
             [self.accountArray addObject:accountID];
             
         }
         self.accountID = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.nameArray,self.accountArray, nil];
         NSLog(@"%@",self.accountID);
         NSLog(@"%@",self.lattitudes);
         NSLog(@"%@",self.longtitudes);
         NSLog(@"%@",self.profilePicArray);
         
         dispatch_async(dispatch_get_main_queue(), ^{
         
         if(self.accountArray.count > 0)
         {
             
             locationlabel.hidden = YES;
             
             for (int i=0;i<=self.lattitudes.count-1; i++)
             {
                 
                 CLLocationCoordinate2D position = CLLocationCoordinate2DMake([[self.lattitudes objectAtIndex:i] floatValue],[[self.longtitudes objectAtIndex:i] floatValue]);
                 
                 self.marker = [GMSMarker markerWithPosition:position];
                 self.marker.title = [self.accountArray objectAtIndex:i];
                 self.marker.snippet = @"MetFlick";
                 
                 
                 
                 NSLog(@"marker title %@",_marker.title);
                 
                 _marker.map = _mapView;
                 if ([[NSString stringWithFormat:@"%@",[self.profilePicArray objectAtIndex:i]]isEqualToString:@""])
                 {
                     UIImage *image = [UIImage imageNamed:@"profile"];
                     NSData *data = [[NSData alloc] init];
                     data = UIImagePNGRepresentation(image);
                     _marker.icon = [UIImage imageWithData:data scale:5.0];
                 }
                 else{
                     _marker.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.profilePicArray objectAtIndex:i]]]] scale:18.0];
                     
                     _marker.map = _mapView;
                 }
                 
             }
         }
         else
         {
             locationlabel.hidden = NO;
             
         }
               });
         
     }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];

  
    

    
}


- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    [mapView animateToLocation:marker.position];
    
    NSLog(@"%@",marker.title);
    
    if([marker.title  isEqual: @"No"])
    {
    
        return  YES;
        
    }
    else
    {
    
    if ([[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] isEqualToString:[NSString stringWithFormat:@"%@",marker.title]] ) {
        
        ProfileViewController *PVC =[self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        [self.navigationController pushViewController:PVC animated:YES];
        
        
        return YES;
    }
    else
    {
        
        WallACFeedsViewController *WACFVC =[self.storyboard instantiateViewControllerWithIdentifier:@"wallProfile"];
        WACFVC.IDStr = [NSString stringWithFormat:@"%@",marker.title];
        [self.navigationController pushViewController:WACFVC animated:YES];
        //[self.tabBarController.navigationController pushViewController:WACFVC animated:YES];
        
       

        return YES;
    }
    return YES;
        
    }
    return YES;
}
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
   
    
   
    
}

/**
 * Called after dragging of a marker ended.
 */
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker
{
    
    
}
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker
{
    [markerAlways.map clear];
}


/**
 * Called while a marker is dragged.
 */
- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker
{
    
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    
     self.parameter = [[NSDictionary alloc]init];
    CLLocation *loc = locations.lastObject;
        double speed = loc.speed;
        NSLog(@"speed-----%f ", speed);
        
         NSLog(@"some %f %f",loc.coordinate.latitude,loc.coordinate.longitude);
        
    
    self.parameter =
    @{
      @"accountId": [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]],
      @"Platform": @"ios",
      @"imei":self.UIDeviceString,
      @"latCode" : [NSString stringWithFormat:@"%@",latitude],
      @"lonCode" : [NSString stringWithFormat:@"%@",longtitude]
      
      };
    
    AFHTTPSessionManager *manager1 = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager1.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager1.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager1 POST:@"http:api.mateflick.host/UpdateGPSLocation/?" parameters:self.parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSLog(@"success!");
        
        
    }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               
               NSLog(@"error: %@", error);
           }];
    
}
//- (id<SINClient>)client {
//    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
//}
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.client.callClient.delegate = self;
//}


@end
