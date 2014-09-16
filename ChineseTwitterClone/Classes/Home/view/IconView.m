//
//  IconView.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/1/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#define kIconSmallWidth 34
#define kIconSmallHeight 34

#define kIconDefaultWidth 50
#define kIconDefaultHeight 50

#define kIconBigWidth 85
#define kIconBigHeight 85

#define kVerifyIconWidth 18
#define kVerifyIconHeight 18

#import "IconView.h"
#import "HttpTool.h"
#import "User.h"

@interface IconView ()
{
    UIImageView *_icon; // profile image
    UIImageView *_verifyIcon; // verification image
    
    NSString *_placeHolder;
}

@end


@implementation IconView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. profile image
        UIImageView *icon = [[UIImageView alloc] init];
        [self addSubview:icon];
        _icon = icon;
        
        // 2. small icon for verification in the right-bottom
        UIImageView *verifyIcon = [[UIImageView alloc] init];
        [self addSubview:verifyIcon];
        _verifyIcon = verifyIcon;
    }
    return self;
}

#pragma mark set user and type simultaneously
- (void)setUser:(User *)user type:(IconType)type
{
    self.type = type;
    self.user = user;
}

#pragma mark set user model
- (void)setUser:(User *)user
{
    _user = user;
    
    // 1. set profile image (network loading)
    [HttpTool downloadImage:user.profileImageUrl placeHolder:[UIImage imageNamed:_placeHolder] imageView:_icon];
    
    // 2. set verify icon
    NSString *verifiedIcon = nil;
    switch (user.verifiedType) {
        case kVerifiedTypeNone:
            _verifyIcon.hidden = YES;
            break;
        case kVerifiedTypeDaren:
            verifiedIcon = @"avatar_grassroot.png";
            _verifyIcon.hidden = NO;
            break;
        case kVerifiedTypePerson:
            verifiedIcon = @"avatar_vip.png";
            _verifyIcon.hidden = NO;
            break;
        default: // enterprise
            verifiedIcon = @"avatar_enterprise_vip.png";
            _verifyIcon.hidden = NO;
            break;
    }
    
    if (verifiedIcon) { // load local image
        _verifyIcon.image = [UIImage imageNamed:verifiedIcon];
    }
}

#pragma mark set type model
- (void)setType:(IconType)type
{
    _type = type;
    
    // 1. check type
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall:
            iconSize = CGSizeMake(kIconSmallWidth, kIconSmallHeight);
            _placeHolder = @"avatar_default_small.png";
            break;
        case kIconTypeDefault:
            iconSize = CGSizeMake(kIconDefaultWidth, kIconDefaultHeight);
            _placeHolder = @"avatar_default.png";
            break;
        case kIconTypeBig:
            iconSize = CGSizeMake(kIconBigWidth, kIconBigHeight);
            _placeHolder = @"avatar_default_big.png";
            break;
    }
    
    // 2. set frame
    _icon.frame = (CGRect){CGPointZero, iconSize};
    _verifyIcon.bounds = CGRectMake(0, 0, kVerifyIconWidth, kVerifyIconHeight);
    _verifyIcon.center = CGPointMake(iconSize.width, iconSize.height);

//    // 3. width and height
    CGFloat viewWidth = iconSize.width + kVerifyIconWidth * 0.5;
    CGFloat viewHeight = iconSize.height + kVerifyIconHeight * 0.5;
    self.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
}

// setFrame method is rewritten so that the size(width, height) is not affected by external calls
- (void)setFrame:(CGRect)frame
{
    frame.size = self.bounds.size;
    [super setFrame:frame];
}

#pragma get icon size by type(small, default, big)
+ (CGSize)iconSizeWithType:(IconType)type
{
    CGSize iconSize;
    switch (type) {
        case kIconTypeSmall:
            iconSize = CGSizeMake(kIconSmallWidth, kIconSmallHeight);
            break;
        case kIconTypeDefault:
            iconSize = CGSizeMake(kIconDefaultWidth, kIconDefaultHeight);
            break;
        case kIconTypeBig:
            iconSize = CGSizeMake(kIconBigWidth, kIconBigHeight);
            break;
    }
    
    CGFloat viewWidth = iconSize.width + kVerifyIconWidth * 0.5;
    CGFloat viewHeight = iconSize.height + kVerifyIconHeight * 0.5;
    
    return CGSizeMake(viewWidth, viewHeight);
}

@end






