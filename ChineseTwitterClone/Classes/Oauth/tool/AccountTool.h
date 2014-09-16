//
//  AccountTool.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/30/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "Account.h"

@interface AccountTool : NSObject

@property (nonatomic, readonly) Account *currentAccount;

singleton_interface(AccountTool)

- (void)saveAccount:(Account *)account;

@end
