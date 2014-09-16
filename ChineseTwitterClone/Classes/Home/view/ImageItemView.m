//
//  ImageItemView.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/3/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "ImageItemView.h"
#import "UIImageView+WebCache.h"
#import "HttpTool.h"

@interface ImageItemView ()
{
    UIImageView *_gifView;
}

@end

@implementation ImageItemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *gifView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif.png"]];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return self;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    // 1. load image
    [HttpTool downloadImage:url placeHolder:[UIImage imageNamed:@"Icon.png"] imageView:self];

    // 2. check if it is gif
    _gifView.hidden = ![url.lowercaseString hasSuffix:@"gif"];
}

- (void)setFrame:(CGRect)frame
{
    // set gif view location
    CGRect gifFrame = _gifView.frame;
    gifFrame.origin.x = frame.size.width - gifFrame.size.width;
    gifFrame.origin.y = frame.size.height - gifFrame.size.height;
    _gifView.frame = gifFrame;
    
    [super setFrame:frame];
}
@end





