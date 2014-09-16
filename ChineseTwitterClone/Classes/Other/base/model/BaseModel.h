//
//  BaseModel.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/8/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
{
    NSString *_createdAt;
}

@property (nonatomic, assign) long long ID;
@property (nonatomic, copy) NSString *createdAt;

- (id)initWithDict:(NSDictionary *)dict;

@end
