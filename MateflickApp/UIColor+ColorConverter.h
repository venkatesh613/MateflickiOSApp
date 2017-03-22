//
//  UIColor+ColorConverter.h
//  MateflickApp
//
//  Created by Safiqul Islam on 08/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorConverter)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
