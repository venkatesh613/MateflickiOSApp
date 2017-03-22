//
//  VideoCallViewController.m
//  MateflickApp
//
//  Created by Safiqul Islam on 20/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "VideoCallViewController.h"
#import "VideoCallViewController+VideoCallAdjustment.h"
#import <Sinch/Sinch.h>
#import <Sinch/SINUIView+Fullscreen.h>
#import <AFNetworking/AFNetworking.h>

@interface VideoCallViewController () <SINCallDelegate,SINCallClientDelegate>
@property BOOL audio;
@property BOOL speaker1;
@property NSMutableArray *userDataStoreArray;
@property NSString *userProfilePicStr;
@property NSString *userFirstNameStr;


@property (weak, nonatomic) IBOutlet UIGestureRecognizer *remoteVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *localVideoFullscreenGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIGestureRecognizer *switchCameraGestureRecognizer;

@end

@implementation VideoCallViewController
- (id<SINClient>)client {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
}
- (id<SINAudioController>)audioController {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}

- (id<SINVideoController>)videoController {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] videoController];
}

- (void)setCall:(id<SINCall>)call {
    _call = call;
    _call.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.callStatus.text = @"";
    
    self.speaker1 = YES;
    self.audio = YES;
  
    if ([self.call direction] == SINCallDirectionIncoming) {
        [self setCallStatusText:@""];
        [self showButtons:kButtonsAnswerDecline1];
        [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
    } else {
        [self setCallStatusText:@"calling..."];
        [self showButtons:kButtonsHangup1];
    }
    
    if ([self.call.details isVideoOffered]) {
        [self.localVideoView addSubview:[[self videoController] localView]];
        
        [self.localVideoFullscreenGestureRecognizer requireGestureRecognizerToFail:self.switchCameraGestureRecognizer];
        [[[self videoController] localView] addGestureRecognizer:self.localVideoFullscreenGestureRecognizer];
        [[[self videoController] remoteView] addGestureRecognizer:self.remoteVideoFullscreenGestureRecognizer];
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.client.callClient.delegate = self;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self audioController] enableSpeaker];
    self.userDataStoreArray = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",[self.call remoteUserId]);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.mateflick.host/UserProfileDetails/?accountId=%@",[self.call remoteUserId]] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        self.userDataStoreArray = [responseObject valueForKey:@"UserProfileDetails"];
        
        NSLog(@"/////////data For Calling %@",self.userDataStoreArray);
        for (NSDictionary *object in self.userDataStoreArray) {
            
            self.userProfilePicStr = object[@"profilePic"];
            self.userFirstNameStr = object[@"firstName"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                self.remoteUsername.text = self.userFirstNameStr;
                
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    //self.remoteUsername.text = [self.call remoteUserId];

    
    
}
- (IBAction)accept:(id)sender {
    [[self audioController] stopPlayingSoundFile];
    [self.call answer];
}

- (IBAction)decline:(id)sender {
    [self.call hangup];
    [self dismiss];
}

- (IBAction)hangup:(id)sender {
    [self.call hangup];
    [self dismiss];
}

- (IBAction)onSwitchCameraTapped:(id)sender {
    AVCaptureDevicePosition current = self.videoController.captureDevicePosition;
    self.videoController.captureDevicePosition = SINToggleCaptureDevicePosition(current);
}

- (IBAction)onFullScreenTapped:(id)sender {
    UIView *view = [sender view];
    if ([view sin_isFullscreen]) {
        view.contentMode = UIViewContentModeScaleAspectFit;
        [view sin_disableFullscreen:YES];
    } else {
        view.contentMode = UIViewContentModeScaleAspectFill;
        [view sin_enableFullscreen:YES];
    }
}

- (void)onDurationTimer:(NSTimer *)unused {
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
    [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call {
    [self setCallStatusText:@"ringing..."];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call {
    [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
    [self showButtons:kButtonsHangup1];
    [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call {
    [self dismiss];
    [[self audioController] stopPlayingSoundFile];
    [self stopCallDurationTimer];
    [[[self videoController] remoteView] removeFromSuperview];
    [[self audioController] disableSpeaker];
}

- (void)callDidAddVideoTrack:(id<SINCall>)call {
    [self.remoteVideoView addSubview:[[self videoController] remoteView]];
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enableSpeaker:(id)sender {
    if(self.speaker1 == YES)
    {
        [self.speaker setBackgroundImage:[UIImage imageNamed:@"UnSpeaker red"] forState:UIControlStateNormal];
        
        [[self audioController] enableSpeaker];
        self.speaker1 = NO;
        
    }
    else
    {
        [self.speaker setBackgroundImage:[UIImage imageNamed:@"muteRed"] forState:UIControlStateNormal];
        
        [[self audioController] disableSpeaker];
        self.speaker1 = YES;
    }
}

- (IBAction)muteBtn:(id)sender
{
    if(self.audio == YES)
    {
        
        // self.mute.imageView.image = [UIImage imageNamed:@""];
        
        [self.mute setBackgroundImage:[UIImage imageNamed:@"um_mute red"] forState:UIControlStateNormal];
        
        [[self audioController] mute];
        self.audio = NO;
    }
    else
    {
        [self.mute setBackgroundImage:[UIImage imageNamed:@"mute_red"] forState:UIControlStateNormal];
        
        [[self audioController] unmute];
        self.audio = YES;
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
