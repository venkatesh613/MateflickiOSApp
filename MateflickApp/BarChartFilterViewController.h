//
//  BarChartFilterViewController.h
//  MateflickApp
//
//  Created by Safiqul Islam on 15/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import <Sinch/Sinch.h>

@interface BarChartFilterViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SINCallClientDelegate>
@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;

- (IBAction)labelSliderChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *genderTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
