//
//  UIImage+Addition.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "UIImage+Addition.h"
#import "NSString+Addition.h"

@implementation UIImage (Addition)

#pragma mark load full screen image
+ (UIImage *)fullScreenImage:(NSString *)imgName
{
    // 1. if it is iPhone5,
    if (iPhone5) {
        imgName = [imgName fileAppend:@"-568h@2x"];
    }
    
    return [self imageNamed:imgName];
}

@end
