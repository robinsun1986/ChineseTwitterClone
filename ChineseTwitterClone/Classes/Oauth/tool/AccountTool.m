//
//  AccountTool.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//  

#import "AccountTool.h"

// file path
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"account.data"]

@implementation AccountTool

singleton_implementation(AccountTool)

// the fowlling method should be rewritten in non-ARC project 
//- (oneway void)release
//{
//    
//}
//
//- (id)retain
//{
//    
//}
//
//- (NSUInteger)retainCount
//{
//    return 1;
//}

- (id)init
{
    if (self = [super init]) {
        _currentAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
    }
    
    return self;
}

- (void)saveAccount:(Account *)account
{
    _currentAccount = account;
    
    [NSKeyedArchiver archiveRootObject:account toFile:kFile];
}

@end
