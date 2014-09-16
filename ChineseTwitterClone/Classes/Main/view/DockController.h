//
//  DockController.h
//  TestDock
//
//  Created by wilson on 8/28/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dock.h"

@interface DockController : UIViewController
{
    Dock *_dock;
}

@property (nonatomic, readonly) UIViewController *selectedController;
@end
