//
//  Account.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "Account.h"

@implementation Account

#pragma mark encode
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_accessToken forKey:@"access_token"];
    [aCoder encodeObject:_uid forKey:@"uid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.accessToken = [aDecoder decodeObjectForKey:@"access_token"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
    }
    
    return self;
}

@end
