//
//  StatusDock.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/4/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusDock.h"
#import "NSString+Addition.h"
#import "UIImage+Addition.h"
#import "Status.h"

@interface StatusDock ()
{
    UIButton *_repost;
    UIButton *_comment;
    UIButton *_like;
}

@end

@implementation StatusDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // auto resize flexible top margin, make sure dock always sits at the bottom of cell
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        // 0. set dock background
        self.image = [UIImage resizedImage:@"timeline_card_bottom.png"];
        
        // 1. add 3 buttons
        _repost = [self addBtn:@"timeline_icon_retweet.png" bg:@"timeline_card_leftbottom.png" index:0];
        _comment = [self addBtn:@"timeline_icon_comment.png" bg:@"timeline_card_middlebottom.png" index:1];
        _like = [self addBtn:@"timeline_icon_unlike.png" bg:@"timeline_card_rightbottom.png" index:2];
    }
    return self;
}

#pragma mark add button
- (UIButton *)addBtn:(NSString *)icon bg:(NSString *)bg index:(int)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // icon
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    // background
    [btn setBackgroundImage:[UIImage resizedImage:bg] forState:UIControlStateNormal];
    // highlight background
    [btn setBackgroundImage:[UIImage resizedImage:[bg fileAppend:@"_highlighted"]] forState:UIControlStateHighlighted];
    [btn setTitleColor:kColor(188, 188, 188) forState:UIControlStateNormal];
    // font size
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    // set frame
    CGFloat w = self.frame.size.width / 3;
    btn.frame = CGRectMake(index * w, 0, w, kStatusDockHeight);
    // title margin
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:btn];
    
    // add divider
    if (index != 0) {
        UIImage *img = [UIImage imageNamed:@"timeline_card_bottom_line.png"];
        UIImageView *divider = [[UIImageView alloc] initWithImage:img];
        divider.center = CGPointMake(btn.frame.origin.x, kStatusDockHeight * 0.5);
        [self addSubview:divider];
    }
    
    return btn;
}

#pragma mark set frame
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width - 2 * kTableBorderWidth;
    frame.size.height = kStatusDockHeight;
    [super setFrame:frame];
}

#pragma mark set status
- (void)setStatus:(Status *)status
{
    _status = status;
    
    [self setBtn:_repost title:@"Repost" count:status.repostsCount];
    [self setBtn:_comment title:@"Comment" count:status.commentsCount];
    [self setBtn:_like title:@"Like" count:status.attitudesCount];
}

#pragma mark set button title text
- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
    NSString *countStr = title;
    if (count) {
        if (count < 1000) {
            countStr = [NSString stringWithFormat:@"%d", count];
        } else if (count < 1000000) {
            countStr = [NSString stringWithFormat:@"%.1fk", count / 1000.0];
        } else {
            countStr = [NSString stringWithFormat:@"%.1fm", count / 1000000.0];
        }
    }
    // remove the .0 character
    countStr = [countStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    [btn setTitle:countStr forState:UIControlStateNormal];
}

@end









