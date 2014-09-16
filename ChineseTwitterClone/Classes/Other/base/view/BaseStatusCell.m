//
//  BaseStatusCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseStatusCell.h"
#import "IconView.h"
#import "ImageListView.h"
#import "UIImage+Addition.h"
#import "BaseStatusCellFrame.h"
#import "Status.h"
#import "User.h"

@interface BaseStatusCell ()
{
    UILabel *_source;
    ImageListView *_image;
    
    UILabel *_retweetedScreenName;
    UILabel *_retweetedText;
    ImageListView *_retweetedImage;
}

@end

@implementation BaseStatusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1. add tweet subviews
        [self addAllSubviews];
        
        // 2. add retweet subviews
        [self addRetweetedAllSubviews];
        
        // 3. set background
        [self setBg];
    }
    return self;
}

#pragma mark set background
- (void)setBg
{
    // default background
    _bg.image = [UIImage resizedImage:@"common_card_background.png"];
    
    // long press background
    _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
}

#pragma mark add tweet all subviews
- (void)addAllSubviews
{
    // 1. source
    _source = [[UILabel alloc] init];
    _source.font = kSourceFont;
    _source.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_source];
    
    // 2. pictures
    _image = [[ImageListView alloc] init];
    [self.contentView addSubview:_image];
}

#pragma mark add retweet all subviews
- (void)addRetweetedAllSubviews
{
    // 1. retweet parent view
    _retweeted = [[UIImageView alloc] init];
    _retweeted.image = [UIImage resizedImage:@"timeline_retweet_background.png" xPos:0.9 yPos:0.5];
    _retweeted.userInteractionEnabled = YES;
    [self.contentView addSubview:_retweeted];
    
    // 2. retweet screen name
    _retweetedScreenName = [[UILabel alloc] init];
    _retweetedScreenName.font = kRetweetedScreenNameFont;
    _retweetedScreenName.textColor = kRetweetSceenNameColor;
    _retweetedScreenName.backgroundColor = [UIColor clearColor];
    [_retweeted addSubview:_retweetedScreenName];
    
    // 2. retweet text
    _retweetedText = [[UILabel alloc] init];
    _retweetedText.font = kRetweetedTextFont;
    _retweetedText.backgroundColor = [UIColor clearColor];
    _retweetedText.numberOfLines = 0;
    [_retweeted addSubview:_retweetedText];
    
    // 4. retweet image
    _retweetedImage = [[ImageListView alloc] init];
    [_retweeted addSubview:_retweetedImage];
}

- (void)setCellFrame:(BaseStatusCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    
    Status *s = cellFrame.status;
    
    // 1. profile image (type -> frame -> user, order is important)
    [_icon setUser:s.user type:kIconTypeSmall];
    _icon.frame = cellFrame.iconFrame;
    //    _icon.type = kIconTypeSmall;
    //    _icon.user = s.user;
    //    [_icon setImageWithURL:[NSURL URLWithString:s.user.profileImageUrl] placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    
    // 2. screen name
    _screenName.frame = cellFrame.screenNameFrame;
    _screenName.text = s.user.screenName;
    if (s.user.mbtype == kMBTypeNone) {
        _screenName.textColor = kScreenNameColor;
        _mbIcon.hidden = YES;
    } else {
        _screenName.textColor = kMBScreenNameColor;
        _mbIcon.hidden = NO;
        _mbIcon.frame = cellFrame.mbIconFrame;
    }
    
    // 3. time
    // time frame needs to be dynamically calculated as it keeps changing over time
    _time.text = s.createdAt;
    CGFloat timeX = cellFrame.screenNameFrame.origin.x;
    CGFloat timeY = CGRectGetMaxY(cellFrame.screenNameFrame) + kCellBorderWidth;
    CGSize timeSize = [_time.text sizeWithFont:kTimeFont];
    _time.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4. source
    // source frame needs to be dynamically calculated as time frame keeps changing over time
    _source.text = s.source;
    CGFloat sourceX = CGRectGetMaxX(_time.frame) + kCellBorderWidth;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [_source.text sizeWithFont:kSourceFont];
    _source.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    // 5. text
    _text.frame = cellFrame.textFrame;
    _text.text = s.text;
    
    // 6. images
    if (s.picUrls.count) {
        _image.hidden = NO;
        _image.frame = cellFrame.imageFrame;
        
        _image.imageUrls = s.picUrls;
        //MyLog(@"pic---%@", s.picUrls);
        //        NSString *imageStr = s.picUrls[0][@"thumbnail_pic"];
        //        NSURL *imageURL = [NSURL URLWithString:imageStr];
        //        [_image setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
    } else {
        _image.hidden = YES;
    }
    
    // 7. retweet
    if (s.retweetedStatus) {
        _retweeted.hidden = NO;
        _retweeted.frame = _cellFrame.retweetedFrame;
        
        // 8. retweet screen name
        _retweetedScreenName.frame = cellFrame.retweetedScreenNameFrame;
        _retweetedScreenName.text = [NSString stringWithFormat:@"@%@", s.retweetedStatus.user.screenName];
        
        // 9. retweet text
        _retweetedText.frame = cellFrame.retweetedTextFrame;
        _retweetedText.text = s.retweetedStatus.text;
        
        // 10. pictures
        if (s.retweetedStatus.picUrls.count) {
            _retweetedImage.hidden = NO;
            _retweetedImage.frame = cellFrame.retweetedImageFrame;
            
            _retweetedImage.imageUrls = s.retweetedStatus.picUrls;
            //            [_retweetedImage setImageWithURL:[NSURL URLWithString:s.retweetedStatus.picUrls[0][@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"Icon.png"] options:SDWebImageRetryFailed | SDWebImageLowPriority];
        } else {
            _retweetedImage.hidden = YES;
        }
        
    } else {
        _retweeted.hidden = YES;
    }

}

#pragma mark set cell frame
- (void)setFrame:(CGRect)frame
{
    //    MyLog(@"%@", NSStringFromCGRect(frame));
    // set left and right margin of cell
    frame.origin.x = kTableBorderWidth;
    frame.size.width -= kTableBorderWidth * 2;
    // set top margin for the first cell
    frame.origin.y += kTableBorderWidth;
    // set cell vertical margin
    frame.size.height -= kCellMargin;
    
    [super setFrame:frame];
}


@end
