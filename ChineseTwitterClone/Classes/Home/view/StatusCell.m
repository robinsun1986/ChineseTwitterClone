//
//  StatusCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/31/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusCell.h"
#import "StatusCellFrame.h"
#import "StatusDock.h"

@interface StatusCell ()
{
    StatusDock *_dock; 
}

@end

@implementation StatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // dock
        CGFloat dockY = self.frame.size.height - kStatusDockHeight;
        _dock = [[StatusDock alloc] initWithFrame:CGRectMake(0, dockY, 0, 0)];
        [self.contentView addSubview:_dock];
    }
    return self;
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    // dock bar
    _dock.status = cellFrame.status;
}

@end









