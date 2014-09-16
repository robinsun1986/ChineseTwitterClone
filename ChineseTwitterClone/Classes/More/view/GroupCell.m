//
//  GroupCell.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/29/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "GroupCell.h"
#import "UIImage+Addition.h"

@interface GroupCell ()
{
    UIImageView *_rightArrow;
    UISwitch *_rightSwitch;
}

@end

@implementation GroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
        
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, 80, 44);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:12];
        _rightLabel = label;
        
        _rightSwitch = [[UISwitch alloc] init];
    }
    return self;
}

- (void)setCellType:(CellType)cellType
{
    _cellType = cellType;

    if (cellType == kCellTypeArrow) {
        self.accessoryView = _rightArrow;
    } else if (cellType == kCellTypeLabel) {
        self.accessoryView = _rightLabel;
    } else if (cellType == kCellTypeNone) {
        self.accessoryView = nil;
    } else if (cellType == kCellTypeSwitch) {
        self.accessoryView = _rightSwitch;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    int count = [_myTableView numberOfRowsInSection:indexPath.section];
    if (count == 1) { // only one row for this section
        _bg.image = [UIImage resizedImage:@"common_card_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_background_highlighted.png"];
    } else if (indexPath.row == 0) { // the first row in this section
        _bg.image = [UIImage resizedImage:@"common_card_top_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_top_background_highlighted.png"];
    } else if (indexPath.row == count - 1) { // the last row in this section
        _bg.image = [UIImage resizedImage:@"common_card_bottom_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted.png"];
    } else { // rows in the middle of the section
        _bg.image = [UIImage resizedImage:@"common_card_middle_background.png"];
        _selectedBg.image = [UIImage resizedImage:@"common_card_middle_background_highlighted.png"];
    }
}

@end
