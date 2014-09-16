//
//  BaseCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/8/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initBg];
    }
    return self;
}

#pragma mark init bg
- (void)initBg
{
    UIImageView *bg = [[UIImageView alloc] init];
    self.backgroundView = bg;
    _bg = bg;
    
    UIImageView *selectedBg = [[UIImageView alloc] init];
    self.selectedBackgroundView = selectedBg;
    _selectedBg = selectedBg;
}
@end