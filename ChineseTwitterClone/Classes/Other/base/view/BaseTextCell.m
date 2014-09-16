//
//  BaseTextCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseTextCell.h"
#import "IconView.h"
#import "BaseText.h"
#import "User.h"
#import "UIImage+Addition.h"
#import "BaseTextCellFrame.h"


@interface BaseTextCell ()
@end

@implementation BaseTextCell

#pragma mark override setIndexPath 
// determine the bg image for the cell
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    // 1. get file name
    int count = [_myTableView numberOfRowsInSection:indexPath.section];
    NSString *bgName = @"statusdetail_comment_background_middle.png";
    NSString *selectedBgName = @"statusdetail_comment_background_middle_highlighted.png";
    if (count - 1 == indexPath.row) { // last row
        bgName = @"statusdetail_comment_background_bottom.png";
        selectedBgName = @"statusdetail_comment_background_bottom_highlighted.png";
    }

    // 2. set bg image
    _bg.image = [UIImage resizedImage:bgName];
    _selectedBg.image = [UIImage resizedImage:selectedBgName];
}

#pragma mark set cell frame
- (void)setCellFrame:(BaseTextCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    BaseText *baseText = cellFrame.baseText;
    
    // 1. icon
    _icon.frame = cellFrame.iconFrame;
    _icon.user = baseText.user;
    
    // 2. screen name
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = baseText.user.screenName;
    
    // 3. membership
    if (baseText.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 4. text
    _text.frame = cellFrame.textFrame;
    _text.text = baseText.text;
    
    // 5. time
    _time.frame = cellFrame.timeFrame;
    _time.text = baseText.createdAt;
}

#pragma mark set cell frame
- (void)setFrame:(CGRect)frame
{
    //    MyLog(@"%@", NSStringFromCGRect(frame));
    // set left and right margin of cell
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    // set top margin for the first cell
    //frame.origin.y += kTableBorderWidth;
    // set cell vertical margin
    //frame.size.height -= kCellMargin;
    
    [super setFrame:frame];
}
@end
