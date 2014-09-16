//
//  GroupCell.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/29/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseCell.h"

typedef enum {
    kCellTypeNone,   // no style
    kCellTypeArrow,  // arrow
    kCellTypeLabel,  // label
    kCellTypeSwitch  // switch
} CellType;         

@interface GroupCell : BaseCell

@property (assign, nonatomic, readonly) UILabel *rightLabel;
@property (assign, nonatomic) CellType cellType;
@property (weak, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end


