//
//  VideoCallViewController+VideoCallAdjustment.h
//  MateflickApp
//
//  Created by Safiqul Islam on 20/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "VideoCallViewController.h"

@interface VideoCallViewController (VideoCallAdjustment)
- (void)setCallStatusText:(NSString *)text;

- (void)showButtons:(EButtonsBar1)buttons;

- (void)setDuration:(NSInteger)seconds;
- (void)startCallDurationTimerWithSelector:(SEL)sel;
- (void)stopCallDurationTimer;
@end
