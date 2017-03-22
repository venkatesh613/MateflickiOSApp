//
//  UIColor+ColorConverter.m
//  MateflickApp
//
//  Created by Safiqul Islam on 08/03/17.
//  Copyright © 2017 safiqul islam. All rights reserved.
//

#import "UIColor+ColorConverter.h"

@implementation UIColor (ColorConverter)
+(UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

@end
