//
//  StatusDetailFrame.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusDetailCellFrame.h"
#import "Status.h"

@implementation StatusDetailCellFrame

- (void)setStatus:(Status *)status
{
    [super setStatus:status];
    
    if (status) {
        _retweetedFrame.size.height += kRetweetDockHeight;
        _cellHeight += kRetweetDockHeight;
    }
}

@end
