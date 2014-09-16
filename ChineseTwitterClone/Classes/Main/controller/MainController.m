//
//  MainController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "MainController.h"
#import "Dock.h"
#import "HomeController.h"
#import "MoreController.h"
#import "MessageController.h"
#import "WBNavigationController.h"
#import "UIBarButtonItem+Addition.h"

#define kDockHeight 44

@interface MainController () <DockDelegate, UINavigationControllerDelegate>
@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. initialise all child controllers
    [self addAllChildControllers];
    
    // 2. initialise dock
    [self addDockItems];
}

#pragma mark add all child controllers
- (void)addAllChildControllers
{
    // set dock background
    _dock.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    
    // home
    HomeController *home = [[HomeController alloc] init];
    WBNavigationController *nav1 = [[WBNavigationController alloc] initWithRootViewController:home];
    nav1.delegate = self;
    [self addChildViewController:nav1];
    
    // message
    MessageController *msg = [[MessageController alloc] init];
    WBNavigationController *nav2 = [[WBNavigationController alloc] initWithRootViewController:msg];
    nav2.delegate = self;
    [self addChildViewController:nav2];
    
    // profile
    UIViewController *me = [[UIViewController alloc] init];
    WBNavigationController *nav3 = [[WBNavigationController alloc] initWithRootViewController:me];
    nav3.delegate = self;
    [self addChildViewController:nav3];
    
    // square
    UIViewController *square = [[UIViewController alloc] init];
    WBNavigationController *nav4 = [[WBNavigationController alloc] initWithRootViewController:square];
    nav4.delegate = self;
    [self addChildViewController:nav4];

    // more
    MoreController *more = [[MoreController alloc] initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nav5 = [[WBNavigationController alloc] initWithRootViewController:more];
    nav5.delegate = self;
    [self addChildViewController:nav5];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 1. if viewcontroller is not rootviewcontroller, stretch the view of navigationcontroller
    UIViewController *root = navigationController.viewControllers[0];
    if (root != viewController) {
        // 2. stretch the view of navigation controller
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height;
        navigationController.view.frame = frame;
        
        // 3. add dock above the rootviewcontroller
        [_dock removeFromSuperview];
        CGRect dockFrame = _dock.frame;
        dockFrame.origin.y = root.view.frame.size.height - _dock.frame.size.height;
        // root view is scroll view
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scroll = (UIScrollView *)root.view;
            dockFrame.origin.y += scroll.contentOffset.y;
        }
        
        _dock.frame = dockFrame;
        [root.view addSubview:_dock];
        
        // 4. add "back" button at the left top
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_back.png" highlightedIcon:@"navigationbar_back_highlighted.png" target:self action:@selector(back)];
    }
}

- (void)back
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];
    if (root == viewController) {
        // 1. restore the height of dock view
        CGRect frame = navigationController.view.frame;
        frame.size.height = [UIScreen mainScreen].applicationFrame.size.height - _dock.frame.size.height;
        navigationController.view.frame = frame;
        
        // 2. add dock above main view
        [_dock removeFromSuperview];
        // restore y value of dock
        CGRect dockFrame = _dock.frame;
        
        dockFrame.origin.y = self.view.frame.size.height - _dock.frame.size.height;
        _dock.frame = dockFrame;
        [self.view addSubview:_dock];
    }
}

#pragma mark add dock
- (void)addDockItems
{
    // 2. populate dock
    [_dock addItemWithIcon:@"tabbar_home.png" selectedIcon:@"tabbar_home_selected.png" title:@"Home"];
    [_dock addItemWithIcon:@"tabbar_message_center.png" selectedIcon:@"tabbar_message_center_selected.png" title:@"Message"];
    [_dock addItemWithIcon:@"tabbar_profile.png" selectedIcon:@"tabbar_profile_selected.png" title:@"Profile"];
    [_dock addItemWithIcon:@"tabbar_discover.png" selectedIcon:@"tabbar_discover_selected.png" title:@"Discover"];
    [_dock addItemWithIcon:@"tabbar_more.png" selectedIcon:@"tabbar_more_selected.png"  title:@"More"];
}

@end








