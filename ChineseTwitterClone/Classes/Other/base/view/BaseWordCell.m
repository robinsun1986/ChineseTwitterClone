//
//  BaseWordCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/8/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseWordCell.h"
#import "IconView.h"

@implementation BaseWordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addMyAllSubviews];
    }
    return self;
}

#pragma mark add all subviews
- (void)addMyAllSubviews
{
    // 1. profile image
    _icon = [[IconView alloc] init];
    _icon.type = kIconTypeSmall;
    [self.contentView addSubview:_icon];
    
    // 2. screen name
    _screenName = [[UILabel alloc] init];
    _screenName.font = kScreenNameFont;
    _screenName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_screenName];
    
    // membership icon
    _mbIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_membership.png"]];
    [self.contentView addSubview:_mbIcon];
    
    // 3. time
    _time = [[UILabel alloc] init];
    _time.font = kTimeFont;
    _time.textColor = kColor(246, 165, 68);
    _time.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_time];
    
    // 4. text
    _text = [[UILabel alloc] init];
    _text.font = kTextFont;
    _text.backgroundColor = [UIColor clearColor];
    _text.numberOfLines = 0;
    [self.contentView addSubview:_text];
}

@end
