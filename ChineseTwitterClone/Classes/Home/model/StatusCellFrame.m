//
//  StatusCellFrame.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/31/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusCellFrame.h"
#import "Status.h"
#import "User.h"
#import "IconView.h"
#import "ImageListView.h"

@implementation StatusCellFrame

- (void)setStatus:(Status *)status
{
    [super setStatus:status];
    
    _cellHeight += kStatusDockHeight;
}

@end









