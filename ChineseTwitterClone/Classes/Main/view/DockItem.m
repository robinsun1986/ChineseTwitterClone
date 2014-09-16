//
//  DockItem.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "DockItem.h"

#define kDockItemSelectedBG @"tabbar_slider.png"

// the percentage of height of the title inside the item
#define kTitleRatio 0.3

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1. text center alignment
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 2. text font
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        // 3. image view content mode
        self.imageView.contentMode = UIViewContentModeCenter;
        // 4. set selected background
        [self setBackgroundImage:[UIImage imageNamed:kDockItemSelectedBG] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark rewrite the way item is highlighted
-(void)setHighlighted:(BOOL)highlighted
{
    //[super setHighlighted:highlighted];
}

#pragma mark adjust imageview frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * ( 1 - kTitleRatio );
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark adjust label frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight - 5;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
