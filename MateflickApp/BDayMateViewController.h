//
//  BDayMateViewController.h
//  MateflickApp
//
//  Created by Safiqul Islam on 01/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import "AppDelegate.h"
#import <Sinch/Sinch.h>

@interface BDayMateViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate,SINCallDelegate,SINCallClientDelegate>
@property CLLocationManager *locationManager;

@property NSMutableArray *lattitudes;
@property NSMutableArray *longtitudes;
@property NSMutableArray *profilePicArray;
@property NSMutableArray *dataArray;
@property NSMutableArray *nameArray;
@property NSMutableArray *response;



@property NSString *latStr;
@property NSString *langStr;
@property NSString *age;
@property NSString *ageStr;
@property NSString *gender;

- (IBAction)enableBtn:(id)sender;

@end
