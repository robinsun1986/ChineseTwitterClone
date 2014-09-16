//
//  BaseTextCellFrame.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseTextCellFrame.h"
#import "IconView.h"
#import "BaseText.h"
#import "User.h"

@implementation BaseTextCellFrame

- (void)setBaseText:(BaseText *)baseText
{
    _baseText = baseText;
    
    // cell width
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width - kTableBorderWidth * 2;
    
    // work out the frames of all subviews based on status content
    
    // 1. profile image
    CGFloat iconX = kCellBorderWidth;
    CGFloat iconY = kCellBorderWidth;
    CGSize iconSize = [IconView iconSizeWithType:kIconTypeSmall];
    _iconFrame = CGRectMake(iconX, iconY, iconSize.width, iconSize.height);
    
    // 2. screen name
    CGFloat screenNameX = CGRectGetMaxX(_iconFrame) + kCellBorderWidth;
    CGFloat screenNameY = iconY;
    CGSize screenNameSize = [baseText.user.screenName sizeWithFont:kScreenNameFont];
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // membership icon
    if (baseText.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconHeight) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconWidth, kMBIconHeight);
    }
    
    // 3. status/comment
    CGFloat textX = screenNameX;
    CGFloat textY = CGRectGetMaxY(_screenNameFrame) + kCellBorderWidth;
    CGFloat textWidth = cellWidth - kCellBorderWidth - textX;
    CGSize textSize = [baseText.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    // 4. time
    CGFloat timeX = textX;
    CGFloat timeY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
    CGSize timeSize = CGSizeMake(textWidth, kTimeFont.lineHeight);
    _timeFrame = (CGRect){{timeX, timeY}, timeSize};
    
    // 5. cell
    _cellHeight = CGRectGetMaxY(_timeFrame) + kCellBorderWidth;
}

@end






