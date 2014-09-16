//
//  BaseStatusCellFrame.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseStatusCellFrame.h"
#import "Status.h"
#import "User.h"
#import "IconView.h"
#import "ImageListView.h"

@implementation BaseStatusCellFrame

- (void)setStatus:(Status *)status
{
    _status = status;
    
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
    CGSize screenNameSize = [status.user.screenName sizeWithFont:kScreenNameFont];
    _screenNameFrame = (CGRect){{screenNameX, screenNameY}, screenNameSize};
    
    // membership icon
    if (status.user.mbtype != kMBTypeNone) {
        CGFloat mbIconX = CGRectGetMaxX(_screenNameFrame) + kCellBorderWidth;
        CGFloat mbIconY = screenNameY + (screenNameSize.height - kMBIconHeight) * 0.5;
        _mbIconFrame = CGRectMake(mbIconX, mbIconY, kMBIconWidth, kMBIconHeight);
    }
    
    // 3. time and 4. source has been moved StatusCell for real-time size adjustment
    
    // 5. text
    CGFloat textX = iconX;
    CGFloat maxY = MAX(CGRectGetMaxY(_sourceFrame), CGRectGetMaxY(_iconFrame));
    CGFloat textY = maxY + kCellBorderWidth;
    CGSize textSize = [status.text sizeWithFont:kTextFont constrainedToSize:CGSizeMake(cellWidth - 2 * kCellBorderWidth, MAXFLOAT)];
    _textFrame = (CGRect){{textX, textY}, textSize};
    
    // 6. pictures
    if (status.picUrls.count) {  // picture exists
        CGFloat imageX = textX;
        CGFloat imageY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGSize imageSize = [ImageListView imageListSizeWithCount:status.picUrls.count];
        _imageFrame = CGRectMake(imageX, imageY, imageSize.width, imageSize.height);
    } else if (status.retweetedStatus) { // 7. retweet exists
        // retweet as a whole
        CGFloat retweetX = textX;
        CGFloat retweetY = CGRectGetMaxY(_textFrame) + kCellBorderWidth;
        CGFloat retweetWidth = cellWidth - 2 * kCellBorderWidth;
        CGFloat retweetHeight = kCellBorderWidth;
        
        // 8. retweet screen name
        CGFloat retweetedScreenNameX = kCellBorderWidth;
        CGFloat retweetedScreenNameY = kCellBorderWidth;
        NSString *retweetedScreeName = [@"@" stringByAppendingString:status.retweetedStatus.user.screenName];
        CGSize retweetedScreenNameSize = [retweetedScreeName sizeWithFont:kRetweetedScreenNameFont];
        _retweetedScreenNameFrame = (CGRect){{retweetedScreenNameX, retweetedScreenNameY}, retweetedScreenNameSize};
        
        // 9. retweet screen text
        CGFloat retweetedTextX = retweetedScreenNameX;
        CGFloat retweetedTextY = CGRectGetMaxY(_retweetedScreenNameFrame) + kCellBorderWidth;
        CGSize retweetedTextSize = [status.retweetedStatus.text sizeWithFont:kRetweetedTextFont constrainedToSize:CGSizeMake(retweetWidth - 2 * kCellBorderWidth, MAXFLOAT)];
        _retweetedTextFrame = (CGRect){{retweetedTextX, retweetedTextY}, retweetedTextSize};
        
        // 10. retweet pictures
        if (status.retweetedStatus.picUrls.count) {
            CGFloat retweetedImageX = retweetedTextX;
            CGFloat retweetedImageY = CGRectGetMaxY(_retweetedTextFrame) + kCellBorderWidth;
            CGSize retweetImageSize = [ImageListView imageListSizeWithCount:status.retweetedStatus.picUrls.count];
            _retweetedImageFrame = CGRectMake(retweetedImageX, retweetedImageY, retweetImageSize.width, retweetImageSize.height);
            
            retweetHeight += CGRectGetMaxY(_retweetedImageFrame);
        } else {
            retweetHeight += CGRectGetMaxY(_retweetedTextFrame);
        }
        
        _retweetedFrame = CGRectMake(retweetX, retweetY, retweetWidth, retweetHeight);
    }
    
    // 11. work out cell height
    _cellHeight = kCellBorderWidth + kCellMargin;
    if (status.picUrls.count) {
        _cellHeight += CGRectGetMaxY(_imageFrame);
    } else if (status.retweetedStatus) {
        _cellHeight += CGRectGetMaxY(_retweetedFrame);
    } else {
        _cellHeight += CGRectGetMaxY(_textFrame);
    }
}

@end
