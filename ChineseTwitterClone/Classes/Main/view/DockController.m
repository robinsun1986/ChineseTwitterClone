//
//  DockController.m
//  TestDock
//
//  Created by wilson on 8/28/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "DockController.h"

#define kDockHeight 44

@interface DockController () <DockDelegate>

@end

@implementation DockController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1. add dock
    [self addDock];
}

#pragma mark add dock
- (void)addDock
{
    // 1. add dock
    Dock *dock = [[Dock alloc] init];
    dock.delegate = self;
    dock.frame = CGRectMake(0, self.view.frame.size.height - kDockHeight, self.view.frame.size.width, kDockHeight);
    [self.view addSubview:dock];
    _dock = dock;
}

#pragma mark dock delegate
- (void)dock:(Dock *)dock itemSelectedFrom:(int)from to:(int)to
{
    if (to < 0 || to >= self.childViewControllers.count) {
        return;
    }
    
    // 1. remove previous controller
    UIViewController *oldVC = self.childViewControllers[from];
    [oldVC.view removeFromSuperview];
    
    // 2. get the controller to be displayed
    UIViewController *newVC = self.childViewControllers[to];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - kDockHeight;
    newVC.view.frame = CGRectMake(0, 0, width, height);
    // 3. add to top of MainController
    _selectedController = newVC;
    [self.view addSubview:newVC.view];
}

@end
