#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

#import "AppDelegate.h"
#import "SINUIViewController.h"

typedef enum {
  kButtonsAnswerDecline,
  kButtonsHangup,
} EButtonsBar;

@interface CallViewController : SINUIViewController

@property (weak, nonatomic) IBOutlet UILabel *remoteUsername;
@property (weak, nonatomic) IBOutlet UILabel *callStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;
@property (weak, nonatomic) IBOutlet UIButton *declineButton;
@property (weak, nonatomic) IBOutlet UIButton *endCallButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
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
