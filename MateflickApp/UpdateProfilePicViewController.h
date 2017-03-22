//
//  UpdateProfilePicViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 24/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <Sinch/Sinch.h>
@interface UpdateProfilePicViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,SINCallClientDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) UIImage *pickedImage;
@property UIImagePickerController *picker;

@property NSString *userProfilePicStr;
@property NSString *userFirstNameStr;
@property NSMutableArray *userDataStoreArray;




@end
