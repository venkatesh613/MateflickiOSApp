//
//  AppDelegate.m
//  MateflickApp
//
//  Created by sudheer-kumar on 20/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "AppDelegate.h"
#import "MateflickApp-Swift.h"

@import Firebase;
@import FBSDKCoreKit;
@import Google;
@import GoogleMaps;
@import GooglePlaces;


@interface AppDelegate ()
///
@property (nonatomic, readwrite, strong) id<SINManagedPush> push;
///
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FIRApp configure];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    self.globelArray =[[NSArray alloc]init];
    
    [GMSServices provideAPIKey:@"AIzaSyA25HAgfZnpsRyjjXnjvsVeXUqCwBEDWZU"];
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyA25HAgfZnpsRyjjXnjvsVeXUqCwBEDWZU"];
    [self requestUserNotificationPermission];
    
    
    ////
//    self.push = [Sinch managedPushWithAPSEnvironment:SINAPSEnvironmentAutomatic];
//    self.push.delegate = self;
//    [self.push setDesiredPushTypeAutomatically];
//    
//    void (^onUserDidLogin)(NSString *) = ^(NSString *userId) {
//        [self.push registerUserNotificationSettings];
//        [self initSinchClientWithUserId:userId];
//    };
  /////
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"UserDidLoginNotification"
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note) {
                                                      [self initSinchClientWithUserId:note.userInfo[@"userId"]];
                                                      ///
//                                                      NSString *userId = note.userInfo[@"userId"];
//                                                      [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
//                                                      [[NSUserDefaults standardUserDefaults] synchronize];
//                                                      onUserDidLogin(userId);
                                                      //

                                                  }];
    
    self.callClient.delegate = self;
    
    return YES;
}
//////
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    self.client.callClient.delegate = self;
//}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self.push application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self.push application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), error);
}





//- (SINLocalNotification *)client:(id<SINCallClient>)client localNotificationForIncomingCall:(id<SINCall>)call
//{
//    
//    return call;
//}





//- (id<SINClient>)client {
//    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.client.callClient.delegate = self;
}
-(void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
//    CallViewController *CVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ACVC"];
//    
//    [self.window.rootViewController.navigationController pushViewController:CVC animated:YES];
    
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
     [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    
    [[GIDSignIn sharedInstance] handleURL:url
                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    // Add any custom logic here.
    return YES;
}
- (void)initSinchClientWithUserId:(NSString *)userId {
    if (!_client) {
        _client = [Sinch clientWithApplicationKey:@"88aebf2e-3717-41d0-a22d-8337b9a38945"
                                applicationSecret:@"7kGQdS2YsEuyKygS+goj5Q=="
                                  environmentHost:@"sandbox.sinch.com"
                                           userId:userId];
        
        _client.delegate = self;
        
        [_client setSupportCalling:YES];
        
        [_client start];
        [_client startListeningOnActiveConnection];
        
        
    }
}
- (void)handleLocalNotification:(UILocalNotification *)notification {
    if (notification) {
        id<SINNotificationResult> result = [self.client relayLocalNotification:notification];
        if ([result isCall] && [[result callResult] isTimedOut]) {

            UIAlertController *control = [UIAlertController alertControllerWithTitle:@"Missed Call" message:[NSString stringWithFormat:@"Missed Call From %@",[[result callResult] remoteUserId]] preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *alert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

            [control addAction:alert];

            [self.window.rootViewController presentViewController:control animated:YES completion:nil];
                          //CVC.call = SINCallKey;
            

        }
    }
}

- (void)requestUserNotificationPermission {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self handleLocalNotification:notification];
    
}

#pragma mark - SINClientDelegate

- (void)clientDidStart:(id<SINClient>)client {
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error {
    NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

- (void)client:(id<SINClient>)client
    logMessage:(NSString *)message
          area:(NSString *)area
      severity:(SINLogSeverity)severity
     timestamp:(NSDate *)timestamp {
    if (severity == SINLogSeverityCritical) {
        NSLog(@"%@", message);
    }
}

////////
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    if (!_client) {
        NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
        if (userId) {
            [self initSinchClientWithUserId:userId];
        }
    }
    [self.client relayRemotePushNotification:userInfo];
}



- (void)managedPush:(id<SINManagedPush>)unused
didReceiveIncomingPushWithPayload:(NSDictionary *)payload
            forType:(NSString *)pushType {
    [self handleRemoteNotification:payload];
}
//- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
//    // Find MainViewController and present CallViewController from it.
//    
//    UIViewController *top = self.window.rootViewController;
//    while (top.presentedViewController) {
//        top = top.presentedViewController;
//    }
//    [top performSegueWithIdentifier:@"callView" sender:call];
//}
////////



- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
}






- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
   

}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
   
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
   }


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"MateflickApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
