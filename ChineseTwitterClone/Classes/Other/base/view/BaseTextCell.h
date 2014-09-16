//
//  BaseTextCell.h
//  ChineseTwitterClone
//
//  Created by wilson on 9/7/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "BaseWordCell.h"

@class BaseTextCellFrame;
@interface BaseTextCell : BaseWordCell

@property (nonatomic, strong) BaseTextCellFrame *cellFrame;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) UITableView *myTableView;

@end
