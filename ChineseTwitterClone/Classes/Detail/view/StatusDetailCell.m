//
//  StatusDetailCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusDetailCell.h"
#import "RetweetDock.h"
#import "BaseStatusCellFrame.h"
#import "Status.h"
#import "StatusDetailController.h"
#import "MainController.h"

@interface StatusDetailCell ()
{
    RetweetDock *_dock;
}

@end

@implementation StatusDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1. dock
        RetweetDock *dock = [[RetweetDock alloc] init];
        dock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        CGFloat x = _retweeted.frame.size.width - dock.frame.size.width;
        CGFloat y = _retweeted.frame.size.height - dock.frame.size.height;
        dock.frame = CGRectMake(x, y, 0, 0);
        _dock = dock;
        [_retweeted addSubview:dock];
        
        // 2. observe retweet tap
        [_retweeted addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRetweet)]];
    }
    return self;
}

- (void)showRetweet
{
    // show retweet
    StatusDetailController *detail = [[StatusDetailController alloc] init];
    detail.status = _dock.status;

    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    [nav pushViewController:detail animated:YES];
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    [super setCellFrame:cellFrame];
    
    // set data for subviews
    _dock.status = cellFrame.status.retweetedStatus;
}

@end
