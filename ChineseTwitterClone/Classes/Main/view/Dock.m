//
//  Dock.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"

@interface Dock()
{
    DockItem *_selectedItem;
}

@end

@implementation Dock

#pragma mark add one item for tab bar
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title
{
    // 1. create item
    DockItem *item = [[DockItem alloc] init];
    [item setTitle:title forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    // listen for item clicking event
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    // 2. add item
    [self addSubview:item];
    
    // 3. adjust item frame
//    [UIView beginAnimations:nil context:nil];
    int count = self.subviews.count;
    // select the first dock item by default
    if (count == 1) {
        [self itemClick:item];
    }
    
    CGFloat height = self.frame.size.height; // dock height
    CGFloat width = self.frame.size.width / count;
    for (int i = 0; i < count; i++) {
        DockItem *dockItem = self.subviews[i];
        dockItem.tag = i;
        dockItem.frame = CGRectMake(width * i, 0, width, height);
    }
//    [UIView commitAnimations];
}

#pragma mark listen for item click
-(void)itemClick:(DockItem *)item
{
    // notify delegate
    if ([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]) {
        [_delegate dock:self itemSelectedFrom:_selectedItem.tag to:item.tag];
    }
    
    _selectedItem.selected = NO;
    item.selected = YES;
    _selectedItem = item;
    
    _selectedIndex = item.tag;
}

@end








