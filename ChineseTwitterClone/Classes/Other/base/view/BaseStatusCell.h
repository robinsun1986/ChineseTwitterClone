//
//  BaseStatusCell.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/6/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseWordCell.h"

@class BaseStatusCellFrame;
@interface BaseStatusCell : BaseWordCell
{
    UIImageView *_retweeted; // parent view of retweeted subviews
}

@property (nonatomic, strong) BaseStatusCellFrame *cellFrame;

@end
