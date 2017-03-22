//
//  UpdateProfilePicViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 24/02/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "UpdateProfilePicViewController.h"
#import "AFNetworking.h"
#import "MateflickApp-Swift.h"


@interface UpdateProfilePicViewController ()

@end

@implementation UpdateProfilePicViewController
{
    NSData *imgData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProfileData];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.navigationItem.title = @"Picture";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    _picker = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
    
    self.userImageView.image = image;
    
    float actualHeight = self.userImageView.image.size.height;
    float actualWidth = self.userImageView.image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [self.userImageView.image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    imgData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)fetchProfileData{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/UserProfileDetails/?accountId=%ld",(long)[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        self.userDataStoreArray = [[NSMutableArray alloc]init];
        self.userProfilePicStr = [[NSString alloc]init];
        self.userFirstNameStr = [[NSString alloc]init];
        self.userDataStoreArray = [responseObject valueForKey:@"UserProfileDetails"];
        for (NSDictionary *object in self.userDataStoreArray) {
            
            self.userProfilePicStr = object[@"profilePic"];
            self.userFirstNameStr = object[@"firstName"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usernameLabel.text = [NSString stringWithFormat:@"Hi,%@",self.userFirstNameStr];
                if ([self.userProfilePicStr  isEqualToString: @""]) {
                    
                }else{
                    self.userImageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userProfilePicStr]]]];
                }
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


- (IBAction)camera:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        
        
        
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.picker.cameraCaptureMode =UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:self.picker animated:true completion:nil];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SORRY!!!"
                                                                       message:@"Device has no camera"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *OK = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     }];
        [alert addAction:OK];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)galleryActionBtn:(UIButton *)sender {
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        _picker= [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:true completion:nil];
        
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"pic"])
    {
        // Get reference to the destination view controller
        UpdateProfileViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.userImageT = [NSString stringWithFormat:@"%@",self.userImageView.image];
    }
}
- (IBAction)updateActionBtn:(UIButton *)sender {
    
    NSDictionary *parameter =
    @{ @"accountid": [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]],
      };
    
    NSString *URLString = @"http://api-v2.mateflick.host/json/GetProfileImage/";
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameter options:0 error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *para = @{
                           @"data":jsonString
                           };
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imgData!= nil) {
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"imag.jpg" mimeType:@"image/jpeg"];
        }
        
    } error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if (imgData == nil) {
                    
                    UIAlertController *alert=   [UIAlertController
                                                 alertControllerWithTitle:@"SORRY!!!"
                                                 message:@"Please take Photo!!!"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *OK = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    
                    [alert addAction:OK];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }else{
                    
//                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                                         bundle:nil];
//                    UpdateProfileViewController *yourViewController =
//                    (UpdateProfileViewController *)
//                    [storyboard instantiateViewControllerWithIdentifier:@"updateProfile"];
//                    [yourViewController performSelector:@selector(saveActionBtn:) withObject:nil afterDelay:0.0];
                    
                   [self.navigationController popViewControllerAnimated:true];
                }
                
            });
            
            if ([responseObject isKindOfClass:[NSArray class]])
            {
                
                NSLog(@"Response == %@",responseObject);
                
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
        
    }]
     resume];

}

@end
