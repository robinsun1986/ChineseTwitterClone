//
//  RetweetDock.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "RetweetDock.h"
#import "UIImage+Addition.h"
#import "NSString+Addition.h"
#import "Status.h"

@interface RetweetDock ()
{
    UIButton *_repost;
    UIButton *_comment;
    UIButton *_like;
}

@end

@implementation RetweetDock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. add 3 buttons
        _repost = [self addBtn:@"timeline_icon_retweet.png" bg:@"timeline_card_leftbottom.png" index:0];
        _comment = [self addBtn:@"timeline_icon_comment.png" bg:@"timeline_card_middlebottom.png" index:1];
        _like = [self addBtn:@"timeline_icon_unlike.png" bg:@"timeline_card_rightbottom.png" index:2];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = 200;
    frame.size.height = 35;
    [super setFrame:frame];
}

#pragma mark add button
- (UIButton *)addBtn:(NSString *)icon bg:(NSString *)bg index:(int)index
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    // icon
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
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
    
    return btn;
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
