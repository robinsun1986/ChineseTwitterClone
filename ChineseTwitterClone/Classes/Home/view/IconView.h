//
//  IconView.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/1/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kIconTypeSmall,
    kIconTypeDefault,
    kIconTypeBig
} IconType;

@class User;
@interface IconView : UIView

@property (nonatomic, strong) User *user;
@property (nonatomic, assign) IconType type;

- (void)setUser:(User *)user type:(IconType)type;
+ (CGSize)iconSizeWithType:(IconType)type;

@end
