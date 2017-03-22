//
//  PostViewController.h
//  MateflickApp
//
//  Created by sudheer-kumar on 30/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>
#import "AppDelegate.h"

@interface PostViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,SINCallClientDelegate>

@property (weak, nonatomic) IBOutlet UITextField *postedTextField;
@property (weak, nonatomic) IBOutlet UIImageView *postedimageView;
@property (strong, nonatomic) UIImage *pickedImage;
@property UIImagePickerController *picker;
@property NSMutableDictionary *jsonDic;
@property NSMutableDictionary *postDict;

@end
