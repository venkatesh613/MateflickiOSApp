#import "CallViewController.h"
#import "CallViewController+UI.h"
#import <Sinch/Sinch.h>
#import <AFNetworking/AFNetworking.h>

@interface CallViewController () <SINCallDelegate,SINCallClientDelegate>
@property BOOL audio;
@property BOOL speaker1;
@property NSMutableArray *userDataStoreArray;
@property NSString *userProfilePicStr;
@property NSString *userFirstNameStr;

@end

@implementation CallViewController
//...
- (id<SINClient>)client {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] client];
}
- (id<SINAudioController>)audioController {
  return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] client] audioController];
}



- (void)setCall:(id<SINCall>)call {
  _call = call;
  _call.delegate = self;
}

#pragma mark - UIViewController Cycle

- (void)viewDidLoad {
  [super viewDidLoad];
    
    self.callStatus.text = @"";
    
    self.speaker1 = YES;
    self.audio = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(client:didReceiveIncomingCall:) name:@"audioCall" object:nil];
  if ([self.call direction] == SINCallDirectionIncoming) {
    [self setCallStatusText:@""];
    [self showButtons:kButtonsAnswerDecline];
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"incoming.wav"] loop:YES];
  } else {
    [self setCallStatusText:@"calling..."];
    [self showButtons:kButtonsHangup];
  }
}
//...
- (void)awakeFromNib {
    [super awakeFromNib];
    self.client.callClient.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
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
               
                    self.userImageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userProfilePicStr]]]];
                
                self.remoteUsername.text = self.userFirstNameStr;
                
            });
            
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    
    
    
  //self.remoteUsername.text = [self.call remoteUserId];
}

#pragma mark - Call Actions

- (IBAction)accept:(id)sender {
  [[self audioController] stopPlayingSoundFile];
    
    self.callStatus.text = @"ESTABLISHED";
    
  [self.call answer];
   
    
}

- (IBAction)decline:(id)sender {
  [self.call hangup];
    
   self.callStatus.text = @"DisConnected";
    
  [self dismiss];
}

- (IBAction)hangup:(id)sender {
  [self.call hangup];
  [self dismiss];
}

- (void)onDurationTimer:(NSTimer *)unused {
  NSInteger duration = [[NSDate date] timeIntervalSinceDate:[[self.call details] establishedTime]];
  [self setDuration:duration];
}

#pragma mark - SINCallDelegate

- (void)callDidProgress:(id<SINCall>)call {
  [self setCallStatusText:@"Ringing..."];
  [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
}

- (void)callDidEstablish:(id<SINCall>)call {
  [self startCallDurationTimerWithSelector:@selector(onDurationTimer:)];
  [self showButtons:kButtonsHangup];
  [[self audioController] stopPlayingSoundFile];
}

- (void)callDidEnd:(id<SINCall>)call {
  [[self audioController] stopPlayingSoundFile];
  [self stopCallDurationTimer];
  [self dismiss];
}

#pragma mark - Sounds

- (NSString *)pathForSound:(NSString *)soundName {
  return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:soundName];
}

#pragma mark - SINCallClientDelegate

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    
    [[self audioController] startPlayingSoundFile:[self pathForSound:@"ringback.wav"] loop:YES];
     call.delegate = self;
     _call = call;
    //[_call answer];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"audioCall" object:nil];
}

- (SINLocalNotification *)client:(id<SINClient>)client localNotificationForIncomingCall:(id<SINCall>)call {
    SINLocalNotification *notification = [[SINLocalNotification alloc] init];
    notification.alertAction = @"Answer";
    notification.alertBody = [NSString stringWithFormat:@"Incoming call from %@", [call remoteUserId]];
    return notification;
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
@end
