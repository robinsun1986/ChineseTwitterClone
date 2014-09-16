//
//  ImageListView.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/2/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#define kCount 9
#define kOneWidth 120
#define kOneHeight 120

#define kMultiWidth 80
#define kMultiHeight 80

#define kMargin 10

#import "ImageListView.h"
#import "ImageItemView.h"

@implementation ImageListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init image views
        for (int i=0; i<kCount; i++) {
            ImageItemView *imageView = [[ImageItemView alloc] init];
            [self addSubview:imageView];
        }
    }
    return self;
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    
    int count = imageUrls.count;
    for (int i=0; i<kCount; i++) {
        // 1. get image view
        ImageItemView *child = self.subviews[i];
        // 2. check if the image is visible
        if (i >= count) {
            child.hidden = YES;
            continue;
        }
        
        child.hidden = NO;
        
        // 3. set image
        child.url = imageUrls[i][@"thumbnail_pic"];

        // 4. set frame
        if (count == 1) {
            // avoid image being stretched
            child.contentMode = UIViewContentModeScaleAspectFit;
            child.frame = CGRectMake(0, 0, kOneWidth, kOneHeight);
        } else {
            // remove the part that exceed the bounds
            child.clipsToBounds =  YES;
            child.contentMode = UIViewContentModeScaleAspectFill;
            int temp = (count == 4 ? 2 : 3);
            int row = i / temp;
            int col = i % temp;
            CGFloat x = (kMultiWidth + kMargin) * col;
            CGFloat y = (kMultiHeight + kMargin) * row;
            child.frame = CGRectMake(x, y, kMultiWidth, kMultiHeight);
        }
    }
}

+ (CGSize)imageListSizeWithCount:(int)count
{
    CGSize size;
    
    if (count == 1) {
        size = CGSizeMake(kOneWidth, kOneHeight);
    } else {
        int countRow = (count == 4 ? 2 : 3);
        int rows = (count + countRow - 1) / countRow;
        int cols = ((count >= 3) ? 3 : count);
        CGFloat width = cols * kMultiWidth + (cols - 1) * kMargin;
        CGFloat height = rows * kMultiHeight + (rows - 1) * kMargin;
        size = CGSizeMake(width, height);
    }
    
    return size;
}

@end














