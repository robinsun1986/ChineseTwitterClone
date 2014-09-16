//
//  Account.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *uid;

@end
