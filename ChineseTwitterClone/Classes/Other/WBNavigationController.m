//
//  WBNavigationController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/28/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "WBNavigationController.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1. all navigation bars across the app - [UINavigationBar appearance], ios 5+
    UINavigationBar *bar = [UINavigationBar appearance];
    // 2. set bg image for navigation bar
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    // 3. set text attributes for navigation bar
    [bar setTitleTextAttributes:@{
       UITextAttributeTextColor: [UIColor blackColor],
     // OC collection(array, map) can contain only OC objects, not struct
UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]
     }];
    
    // 4. Change the appearance of all UIBarButtonItem
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    NSDictionary *dict = @{
                           UITextAttributeTextColor: [UIColor grayColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]
                           };
    // change text attributes on bar button item
    [barItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
    [super pushViewController:viewController animated:YES];
}

@end






