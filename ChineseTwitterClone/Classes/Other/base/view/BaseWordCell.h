//
//  BaseWordCell.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/8/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseCell.h"

@class IconView;
@interface BaseWordCell : BaseCell
{
    IconView *_icon;
    UILabel *_screenName;
    UIImageView *_mbIcon; // membership icon
    UILabel *_text;
    UILabel *_time;
}
@end
