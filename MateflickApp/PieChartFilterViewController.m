//
//  PieChartFilterViewController.m
//  MateflickApp
//
//  Created by Safiqul Islam on 16/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "PieChartFilterViewController.h"
#import "AppDelegate.h"
#import "MateflickApp-Swift.h"

NSMutableArray *gender12;
NSMutableArray *countries12;
BOOL a = YES;
BOOL b = YES;
@interface PieChartFilterViewController ()

@end

@implementation PieChartFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    
    self.genderTextField.delegate = self;
    self.countryTextField.delegate = self;
    
    
    [self configureLabelSlider];
    
    gender12 = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female", nil];
    countries12 = [[NSMutableArray alloc] initWithObjects:@"Albania",
                 @"Algeria" ,
                 
                 @"Andorra" ,
                 
                 @"Angola" ,
                 
                 @"Antarctica" ,
                 
                 @"Argentina" ,
                 
                 @"Armenia" ,
                 
                 @"Aruba" ,
                 
                 @"Australia" ,
                 
                 @"Austria" ,
                 
                 @"Azerbaijan",
                 
                 @"Bahrain" ,
                 
                 @"Bangladesh" ,
                 
                 @"Belarus" ,
                 
                 @"Belgium" ,
                 
                 @"Belize" ,
                 
                 @"Benin" ,
                 
                 @"Bhutan" ,
                 
                 @"Bolivia" ,
                 
                 @"Bosnia and Herzegovina" ,
                 
                 @"Botswana" ,
                 
                 @"Brazil" ,
                 
                 @"British Indian Ocean Territory" ,
                 
                 @"Brunei" ,
                 
                 @"Bulgaria" ,
                 
                 @"Burkina Faso" ,
                 @"Burundi" ,
                 
                 @"Cambodia" ,
                 
                 @"Cameroon" ,
                 
                 @"Canada" ,
                 
                 @"Cape Verde" ,
                 
                 @"Central African Republic" ,
                 
                 @"Chad" ,
                 
                 @"Chile" ,
                 
                 @"China" ,
                 
                 @"Christmas Island" ,
                 
                 @"Cocos Islands" ,
                 
                 @"Colombia" ,
                 
                 @"Comoros" ,
                 
                 @"Cook Islands" ,
                 
                 @"Costa Rica" ,
                 
                 @"Croatia" ,
                 
                 @"Cuba" ,
                 
                 @"Curacao" ,
                 
                 @"Cyprus" ,
                 
                 @"Czech Republic" ,
                 
                 @"Democratic Republic of the Congo" ,
                 
                 @"Denmark" ,
                 
                 @"Djibouti" ,
                 
                 @"East Timor",
                 
                 @"Ecuador",
                 
                 @"Egypt" ,
                 
                 @"El Salvador" ,
                 
                 @"Equatorial Guinea" ,
                 
                 @"Eritrea" ,
                 
                 @"Estonia" ,
                 
                 @"Ethiopia" ,
                 
                 @"Falkland Islands" ,
                 @"Faroe Islands" ,
                 
                 @"Fiji" ,
                 
                 @"Finland" ,
                 
                 @"France" ,
                 
                 @"French Polynesia" ,
                 
                 @"Gabon" ,
                 @"Gambia" ,
                 
                 @"Georgia" ,
                 
                 @"Germany" ,
                 
                 @"Ghana" ,
                 
                 @"Gibraltar" ,
                 
                 @"Greece" ,
                 
                 @"Greenland" ,
                 
                 @"Guatemala" ,
                 
                 @"Guinea" ,
                 
                 @"Guinea-Bissau" ,
                 @"Guyana" ,
                 
                 @"Haiti" ,
                 
                 @"Honduras" ,
                 
                 @"Hong Kong" ,
                 
                 @"Hungary" ,
                 
                 @"Iceland" ,
                 
                 @"India" ,
                 
                 @"Indonesia" ,
                 
                 @"Iran" ,
                 
                 @"Iraq" ,
                 
                 @"Ireland" ,
                 
                 @"Israel" ,
                 
                 @"Italy" ,
                 
                 @"Ivory Coast" ,
                 
                 @"Japan" ,
                 
                 @"Jordan" ,
                 
                 @"Kazakhstan" ,
                 
                 @"Kenya" ,
                 
                 @"Kiribati" ,
                 
                 @"Kosovo" ,
                 
                 @"Kuwait" ,
                 
                 @"Kyrgyzstan",
                 
                 @"Laos" ,
                 
                 @"Latvia" ,
                 
                 @"Lebanon" ,
                 
                 @"Lesotho" ,
                 
                 @"Liberia" ,
                 
                 @"Libya" ,
                 
                 @"Liechtenstein" ,
                 
                 
                 @"Lithuania" ,
                 
                 @"Luxembourg" ,
                 
                 @"Macau" ,
                 
                 @"Macedonia" ,
                 
                 @"Madagascar" ,
                 
                 @"Malawi" ,
                 
                 @"Malaysia" ,
                 
                 @"Maldives" ,
                 @"Mali" ,
                 
                 @"Malta" ,
                 
                 @"Marshall Islands" ,
                 
                 @"Mauritania" ,
                 @"Mauritius" ,
                 
                 @"Mayotte" ,
                 
                 @"Mexico" ,
                 
                 @"Micronesia" ,
                 
                 @"Moldova" ,
                 
                 @"Monaco" ,
                 
                 @"Mongolia" ,
                 
                 @"Montenegro" ,
                 
                 @"Morocco" ,
                 
                 @"Mozambique" ,
                 
                 @"Myanmar" ,
                 
                 @"Namibia" ,
                 
                 @"Nauru" ,
                 
                 @"Nepal" ,
                 
                 @"Netherlands" ,
                 
                 @"Netherlands Antilles" ,
                 
                 @"New Caledonia" ,
                 
                 @"New Zealand" ,
                 @"Nicaragua" ,
                 
                 @"Niger" ,
                 
                 @"Nigeria" ,
                 
                 
                 @"Niue" ,
                 
                 @"North Korea" ,
                 
                 @"Norway" ,
                 @"Oman" ,
                 
                 @"Pakistan" ,
                 
                 @"Palau" ,
                 
                 @"Palestine" ,
                 
                 @"Panama" ,
                 
                 @"Papua New Guinea",
                 
                 @"Paraguay" ,
                 
                 @"Peru" ,
                 
                 @"Philippines" ,
                 
                 @"Pitcairn" ,
                 
                 @"Poland" ,
                 @"Portugal" ,
                 
                 @"Qatar" ,
                 
                 @"Republic of the Congo" ,
                 
                 @"Reunion" ,
                 
                 @"Romania" ,
                 
                 
                 @"Russia" ,
                 
                 @"Rwanda" ,
                 
                 @"Saint Barthelemy" ,
                 
                 @"Saint Helena" ,
                 
                 @"Saint Martin" ,
                 
                 @"Saint Pierre and Miquelon",
                 
                 @"Samoa" ,
                 
                 @"San Marino" ,
                 
                 @"Sao Tome and Principe" ,
                 
                 @"Saudi Arabia",
                 
                 @"Senegal" ,
                 
                 @"Serbia" ,
                 
                 @"Seychelles" ,
                 
                 @"Sierra Leone" ,
                 
                 @"Singapore" ,
                 
                 @"Slovakia" ,
                 
                 @"Slovenia" ,
                 
                 @"Solomon Islands",
                 
                 @"Somalia" ,
                 
                 
                 @"South Africa" ,
                 
                 @"South Korea" ,
                 
                 @"South Sudan" ,
                 
                 @"Spain" ,
                 
                 @"Sri Lanka" ,
                 
                 @"Sudan" ,
                 
                 @"Suriname" ,
                 
                 @"Svalbard and Jan Mayen" ,
                 
                 @"Swaziland" ,
                 
                 @"Sweden" ,
                 
                 @"Switzerland" ,
                 @"Syria" ,
                 
                 @"Taiwan" ,
                 
                 @"Tajikistan" ,
                 @"Tanzania" ,
                 
                 @"Thailand" ,
                 @"Togo" ,
                 
                 @"Tokelau" ,
                 
                 @"Tonga" ,
                 
                 @"Tunisia" ,
                 
                 @"Turkey",
                 
                 @"Turkmenistan",
                 
                 @"Tuvalu" ,
                 
                 @"Uganda" ,
                 
                 @"Ukraine" ,
                 
                 @"United Arab Emirates" ,
                 @"United Kingdom" ,
                 
                 @"United States" ,
                 
                 @"Uruguay" ,
                 
                 @"Uzbekistan" ,
                 
                 @"Vanuatu" ,
                 
                 @"Vatican" ,
                 
                 @"Venezuela",
                 
                 @"Vietnam" ,
                 
                 @"Wallis and Futuna" ,
                 
                 @"Western Sahara" ,
                 
                 @"Yemen" ,
                 
                 @"Zambia" ,
                 
                 @"Zimbabwe" , nil];

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


- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    
    self.labelSlider.minimumRange = 5;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}

// Handle control value changed events just like a normal slider


- (IBAction)labelSliderChanged:(id)sender
{
    [self updateSliderLabels];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(a == YES)
    {
        return gender12.count;
    }
    else if (b == YES)
    {
        return countries12.count;
        
    }
    else
    {
    }
    return 0;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.genderTextField)
    {
        a = YES;
        b = NO;
        return YES;
        
    }
    else if(textField ==self.countryTextField)
    {
        b = YES;
        a = NO;
        return YES;
        
    }
    else
    {
        return NO;
    }
    
    
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(a == YES)
    {
        a = YES;
        self.tableView.hidden = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
        b = NO;
    }
    else if(b == YES)
    {
        b = YES;
        self.tableView.hidden = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadData];
        a = NO;
    }
    else
    {
        
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    
    if(a == YES)
    {
        cell.textLabel.text = [gender12 objectAtIndex:indexPath.row];
    }
    else if(b ==YES)
    {
        cell.textLabel.text = [countries12 objectAtIndex:indexPath.row];
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(a == YES)
    {
        self.genderTextField.text = [gender12 objectAtIndex:indexPath.row];
        self.tableView.hidden = YES;
    }
    else if(b == YES)
    {
        self.countryTextField.text = [countries12 objectAtIndex:indexPath.row];
        self.tableView.hidden = YES;
    }
    else
    {
        
    }
    
    
}
- (IBAction)filterButton:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    app.repeat1++;
    app.gender = self.genderTextField.text;
    app.country = self.countryTextField.text;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:_lowerLabel.text];
    
    NSNumberFormatter *f1 = [[NSNumberFormatter alloc] init];
    f1.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber1 = [f numberFromString:self.upperLabel.text];
    
    app.lowAge = myNumber;
    app.highAge = myNumber1;
    //NSLog(@"%@\n %d\n",app.gender,app.lowAge);
    self.tableView.hidden = YES;
    
    BarViewController *BVC12 =[self.storyboard instantiateViewControllerWithIdentifier:@"Pie"];
    
    [self.navigationController pushViewController:BVC12 animated:YES];
    
    //[self.tabBarController.navigationController]
    //[self presentViewController:PVC12 animated:YES completion:nil];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
