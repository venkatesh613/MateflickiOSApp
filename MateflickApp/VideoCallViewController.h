//
//  VideoCallViewController.h
//  MateflickApp
//
//  Created by Safiqul Islam on 20/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

#import "AppDelegate.h"
#import "SINUIViewController.h"
typedef enum  {
    kButtonsAnswerDecline1,
    kButtonsHangup1,
} EButtonsBar1;

@interface VideoCallViewController : SINUIViewController

@property (weak, nonatomic) IBOutlet UILabel *remoteUsername;
@property (weak, nonatomic) IBOutlet UILabel *callStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIView *remoteVideoView;
@property (weak, nonatomic) IBOutlet UIView *localVideoView;
@property (weak, nonatomic) IBOutlet UILabel *callStatus;

@property (nonatomic, readwrite, strong) NSTimer *durationTimer;

@property (nonatomic, readwrite, strong) id<SINCall> call;

- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;
- (IBAction)hangup:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *speaker;
@property (weak, nonatomic) IBOutlet UIButton *mute;

- (IBAction)enableSpeaker:(id)sender;

- (IBAction)muteBtn:(id)sender;

@end
