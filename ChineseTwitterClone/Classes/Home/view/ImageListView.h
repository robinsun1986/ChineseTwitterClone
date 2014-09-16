//
//  ImageListView.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/2/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//  Image List (1~9 images)

#import <UIKit/UIKit.h>

@interface ImageListView : UIView

// image urls
@property (nonatomic, strong) NSArray *imageUrls;

+ (CGSize)imageListSizeWithCount:(int)count;

@end
