//
//  DetailHeader.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "DetailHeader.h"
#import "Status.h"

@interface DetailHeader ()
{
    UIButton *_selectedBtn;
}
@end

@implementation DetailHeader

#pragma mark observe button click
- (IBAction)btnClick:(UIButton *)sender {
    // set state
    _selectedBtn.enabled = YES;
    sender.enabled = NO;
    _selectedBtn = sender;
    
    // move arrow indicator
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = _hint.center;
        center.x = sender.center.x;
        _hint.center = center;
    }];
    
    DetailHeaderBtnType type = (sender == _repost) ? kDetailHeaderBtnTypeRepost : kDetailHeaderBtnTypeComment;
    _currentBtnType = type;
    
    // notify delegate
    int idx = _selectedBtn==_repost ? kDetailHeaderBtnTypeRepost : kDetailHeaderBtnTypeComment;
    if ([_delegate respondsToSelector:@selector(detailHeader:btnClick:)]) {
        
        [_delegate detailHeader:self btnClick:idx];
    }
}

+ (id)header
{
    return [[NSBundle mainBundle] loadNibNamed:@"DetailHeader" owner:nil options:nil][0];
}

- (void)awakeFromNib
{
    self.backgroundColor = kGlobalBg;
    [self btnClick:_comment];
}

// xib did it
//- (void)drawRect:(CGRect)rect
//{
//    UIImage *image = [UIImage resizedImage:@"statusdetail_comment_top_background.png"];
//    [image drawInRect:rect];
//}

- (void)setStatus:(Status *)status
{
    _status = status;
    
    [self setBtn:_comment title:@"Comment" count:status.commentsCount];
    [self setBtn:_repost title:@"Repost" count:status.repostsCount];
    [self setBtn:_like title:@"Like" count:status.attitudesCount];
}

#pragma mark set button title text
- (void)setBtn:(UIButton *)btn title:(NSString *)title count:(int)count
{
    NSString *countStr = title;
    if (count < 1000) {
        countStr = [NSString stringWithFormat:@"%d ", count];
    } else if (count < 1000000) {
        countStr = [NSString stringWithFormat:@"%.1fk ", count / 1000.0];
    } else {
        countStr = [NSString stringWithFormat:@"%.1fm ", count / 1000000.0];
    }
    // remove the .0 character
    countStr = [[countStr stringByReplacingOccurrencesOfString:@".0" withString:@""] stringByAppendingString:title];
    [btn setTitle:countStr forState:UIControlStateNormal];
}

@end






