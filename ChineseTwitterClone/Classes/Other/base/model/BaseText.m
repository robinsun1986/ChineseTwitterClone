//
//  BaseText.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseText.h"
#import "User.h"

@implementation BaseText

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        self.text = dict[@"text"];
        self.user = [[User alloc] initWithDict:dict[@"user"]];
    }
    
    return self;
}

// override getter to update time label dynamically on table scroll
- (NSString *)createdAt
{
    // Tue Sep 02 19:03:43 +0800 2014
    // 1. convert time string to NSDate object
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss zzzz yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
    NSDate *date = [fmt dateFromString:_createdAt];
    
    // 2. compare NSDate with current time and generate reasonable string
    NSDate *now = [NSDate date];
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    NSString *timeStr;
    if (delta < 60) { // in one minute
        timeStr = [NSString stringWithFormat:@"%.fs ago", delta];
    } else if (delta < 60 * 60) { // in one hour
        timeStr = [NSString stringWithFormat:@"%.fm ago", delta/60];
    } else if (delta < 60 * 60 * 24) { // in one day
        timeStr = [NSString stringWithFormat:@"%.fh ago", delta/60/60];
    } else {
        fmt.dateFormat = @"MM-dd HH:mm";
        timeStr = [fmt stringFromDate:date];
    }
    
    return timeStr;
}

@end
