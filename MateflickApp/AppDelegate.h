//
//  AppDelegate.h
//  MateflickApp
//
//  Created by sudheer-kumar on 20/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Sinch/Sinch.h>
#import "CallViewController.h"
#import "VideoCallViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate,SINClientDelegate,SINCallClientDelegate,SINManagedPushDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) id<SINClient> client;
@property (strong, nonatomic) id<SINCallClient> callClient;
@property NSString *gender;
@property NSString *country;
@property NSNumber *lowAge;
@property NSNumber *highAge;
@property BOOL barBool;
@property BOOL pieBool;
@property BOOL lineBool;



@property int repeat;
@property int repeat1;
@property int repeat2;

- (void)awakeFromNib;


- (void)saveContext;
@property NSArray *globelArray;


@end

