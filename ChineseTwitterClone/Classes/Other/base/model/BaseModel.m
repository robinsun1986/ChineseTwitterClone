//
//  BaseModel.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/8/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.ID = [dict[@"id"] longLongValue];
        self.createdAt = dict[@"created_at"];
    }
    
    return self;
}

@end
