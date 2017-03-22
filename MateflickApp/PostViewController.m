//
//  PostViewController.m
//  MateflickApp
//
//  Created by sudheer-kumar on 30/01/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "PostViewController.h"
#import "AFNetworking.h"


@interface PostViewController ()

@end

@implementation PostViewController
{
    NSData *imgData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    [self.postedTextField becomeFirstResponder];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.hidden = false;

    
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
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    _picker = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
    
     self.postedimageView.image = image;
    
    float actualHeight = self.postedimageView.image.size.height;
    float actualWidth = self.postedimageView.image.size.width;
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
    [self.postedimageView.image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    imgData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    [picker dismissViewControllerAnimated:YES completion:nil];
    
   }
- (IBAction)imagepickerViewActionBtn:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Add Photo!"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* camera = [UIAlertAction
                         actionWithTitle:@"Take Photo"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
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
                                     }];

    UIAlertAction* library = [UIAlertAction
                             actionWithTitle:@"Choose from Library"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                                 {
                                     
                                     _picker= [[UIImagePickerController alloc] init];
                                     _picker.delegate = self;
                                     _picker.allowsEditing = YES;
                                _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                [self presentViewController:self.picker animated:true completion:nil];

                            }
                             }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    alert.view.tintColor = [UIColor blackColor];
    [self presentViewController:alert animated:YES completion:nil];
    
}
    
- (IBAction)postActionBtn:(id)sender
{
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd  HH:mm:ss:SSS"];
    NSString *str =[[NSString alloc]init];
    str = [df stringFromDate:today];
    
    NSDictionary *parameter =
    @{
        @"contentStatus": @"published",
        @"contentType": @"Test/Image",
        @"dateTime": str,
        @"ownerId": [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]],
        @"ownerType": @"self",
        @"postedOn": @"wall",
        @"postedOnId": [NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"id"]],
        @"publicContent": @"Yes",
        @"text": self.postedTextField.text
        };

    NSString *URLString = @"http://api-v2.mateflick.host/json/PostContent/";
    
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
    
    // [req setHTTPBody:[[NSString stringWithFormat:@"data=%@",jsonString] dataUsingEncoding:NSUTF8StringEncoding]];
     //[req setHTTPBody:[[NSString stringWithFormat:@"file=%@",contentJSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Reply JSON: %@", responseObject);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([self.postedTextField.text isEqualToString: @""]) {
                    
                    UIAlertController *alert=   [UIAlertController
                                                 alertControllerWithTitle:@"SORRY!!!"
                                                 message:@"Please fill what's on your mind!!!"
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
