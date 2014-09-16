//
//  NewfeatureController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "NewfeatureController.h"
#import "UIImage+Addition.h"
#import "OauthController.h"

#define kCount 4

@interface NewfeatureController () <UIScrollViewDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
}

@end

@implementation NewfeatureController

#pragma mark - custom view
- (void)loadView
{
    //[super loadView];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage fullScreenImage:@"new_feature_background.png"];
    // the size of imageview must be set otherwise it is 0, 0
    imageView.frame = [UIScreen mainScreen].applicationFrame;
    /*
     NOTE: imageView by default does not receive any touch event,
     since here imageView is the root view of controller, 
     the touch event cannot be propagated to subviews if parentview(imageview) do not accept it
     */
    imageView.userInteractionEnabled = YES;
    /*
     take 3.5 inche screen(320x480) as example,
     1> if there is no status bar, applicationFrame = {0, 0, 320, 480}
     2> if status bar exists, applicationFrame = {0, 0, 320, 460}
     
     but bounds is always {0, 0, 320, 480} regardless of whether status bar exists or not
     */
    self.view = imageView;
}

/*
 if an controller cannot show, the reason can be
 1. width and height are not set
 2. position is incorret
 3. hidden = YES
 4. view is not added 
 
 if scrollview cannot scroll, the reason can be
 1. contentSize is not set
 2. touch event is not received
 */
- (void)viewDidLoad
{
    [super viewDidLoad];

    // 1. add UIScrollView
    [self addScrollView];
    
    // 2. add images
    [self addScrollImages];
    
    // 3. add UIPageControl
    [self addPageControl];
}

#pragma mark - UI init
#pragma mark add scrollview
- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO;
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}

#pragma mark add scroll images
- (void)addScrollImages
{
    CGSize size = self.view.frame.size;
    for (int i = 0; i < kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        // show image
        NSString *name = [NSString stringWithFormat:@"new_feature_%d.png", i + 1];
        imageView.image = [UIImage fullScreenImage:name];
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        imageView.userInteractionEnabled = YES;
        [_scroll addSubview:imageView];
        
        // last page has 2 buttons
        if (i == kCount - 1) {
            // start now
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *startNormal = [UIImage imageNamed:@"new_feature_finish_button.png"];
            [start setBackgroundImage:startNormal forState:UIControlStateNormal];
            [start setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted.png"] forState:UIControlStateHighlighted];
            start.center = CGPointMake(size.width * 0.5, size.height * 0.8);
            start.bounds = (CGRect){CGPointZero, startNormal.size};
            [start addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            
            // share
            UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *shareNormal = [UIImage imageNamed:@"new_feature_share_true.png"];
            [share setBackgroundImage:shareNormal forState:UIControlStateSelected];
            [share setBackgroundImage:[UIImage imageNamed:@"new_feature_share_false.png"] forState:UIControlStateNormal];
            share.center = CGPointMake(start.center.x, start.center.y - 50);
            share.bounds = (CGRect){CGPointZero, shareNormal.size};
            [share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            //            share.enabled = NO;
            share.selected = YES;
            // do not make the button gray when highlighted
            share.adjustsImageWhenHighlighted = NO;
            [imageView addSubview:share];
        }
    }
}

#pragma mark add page control
- (void)addPageControl
{
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:page];
    _page = page;
}

#pragma mark - button click listener
#pragma mark - start
- (void)start
{
    MyLog(@"start weibo");
    // need to be set before the view is displayed
    [UIApplication sharedApplication].statusBarHidden = NO;
    //self.view.window.rootViewController = [[MainController alloc] init];
    self.view.window.rootViewController = [[OauthController alloc] init];
}

#pragma mark - share
- (void)share:(UIButton *)btn
{
    btn.selected = !btn.selected;
    MyLog(@"share weibo");
}

#pragma mark - scroll delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

@end











