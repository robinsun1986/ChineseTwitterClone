//
//  BaseStatusCellFrame.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Status;
@interface BaseStatusCellFrame : NSObject
{
    // define property variables for subclass to access 
    CGFloat _cellHeight;
    CGRect _retweetedFrame;
}

@property (nonatomic, strong) Status *status;

@property (nonatomic, readonly) CGFloat cellHeight;

@property (nonatomic, readonly) CGRect iconFrame;
@property (nonatomic, readonly) CGRect screenNameFrame;
@property (nonatomic, readonly) CGRect mbIconFrame;
@property (nonatomic, readonly) CGRect timeFrame;
@property (nonatomic, readonly) CGRect sourceFrame;
@property (nonatomic, readonly) CGRect textFrame;
@property (nonatomic, readonly) CGRect imageFrame;

@property (nonatomic, readonly) CGRect retweetedFrame;
@property (nonatomic, readonly) CGRect retweetedScreenNameFrame;
@property (nonatomic, readonly) CGRect retweetedTextFrame;
@property (nonatomic, readonly) CGRect retweetedImageFrame;
@end
