//
//  User.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super initWithDict:dict]) {
        
        self.screenName = dict[@"screen_name"];
        self.profileImageUrl = dict[@"profile_image_url"];
        self.verified = [dict[@"verified"] boolValue];
        self.verifiedType = [dict[@"verified_type"] intValue];
        self.mbrank = [dict[@"mbrank"] intValue];
        self.mbtype = [dict[@"mbtype"] intValue];
        
        //[self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
