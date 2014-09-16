//
//  BaseTextCellFrame.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseText;
@interface BaseTextCellFrame : NSObject

@property (nonatomic, strong) BaseText *baseText;
@property (nonatomic, readonly) CGFloat cellHeight;

@property (nonatomic, readonly) CGRect iconFrame;
@property (nonatomic, readonly) CGRect screenNameFrame;
@property (nonatomic, readonly) CGRect mbIconFrame;
@property (nonatomic, readonly) CGRect timeFrame;
@property (nonatomic, readonly) CGRect textFrame;
@end
