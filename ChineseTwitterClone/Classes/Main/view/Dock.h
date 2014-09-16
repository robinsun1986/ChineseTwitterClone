//
//  Dock.h
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Dock;

@protocol DockDelegate <NSObject>
@optional
-(void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to;

@end

@interface Dock : UIView

// add one item for tab bar
-(void)addItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selected title:(NSString *)title;

@property (nonatomic, weak) id<DockDelegate> delegate;

@property (nonatomic, assign) int selectedIndex;
@end
