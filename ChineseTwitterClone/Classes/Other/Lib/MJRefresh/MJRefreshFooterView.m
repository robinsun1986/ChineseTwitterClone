//
//  MJRefreshFooterView.m
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013. All rights reserved.
//  

#define kPullToRefresh @"Pull up to load more"
#define kReleaseToRefresh @"Release to load more"
#define kRefreshing @"Loading..."

#import "MJRefreshFooterView.h"

@implementation MJRefreshFooterView

+ (id)footer
{
    return [[MJRefreshFooterView alloc] init];
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        // remove the label showing last update time
		[_lastUpdateTimeLabel removeFromSuperview];
        _lastUpdateTimeLabel = nil;
    }
    return self;
}

#pragma mark - UIScrollView Related
#pragma mark override to configure scrollview
- (void)setScrollView:(UIScrollView *)scrollView
{
    // 1. remove observer
    [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    // 2. listen for contentSize
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    // 3. super class method
    [super setScrollView:scrollView];
    
    // 4. adjust frame
    [self adjustFrame];
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
    [super removeFromSuperview];
}

#pragma mark observe UIScrollView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self adjustFrame];
    }
}

#pragma mark override to adjust frame
- (void)adjustFrame
{
    // content height
    CGFloat contentHeight = _scrollView.contentSize.height;
    // scroll height
    CGFloat scrollHeight = _scrollView.frame.size.height;
    CGFloat y = MAX(contentHeight, scrollHeight);
    // set frame
    self.frame = CGRectMake(0, y, _scrollView.frame.size.width, kViewHeight);
    
    // move label
    CGPoint center = _statusLabel.center;
    center.y = _arrowImage.center.y;
    _statusLabel.center = center;
}

#pragma mark - State Related
#pragma mark set state
- (void)setState:(RefreshState)state
{
    if (_state == state) return;
    
    [super setState:state];
    
	switch (_state = state)
    {
		case RefreshStatePulling:
        {
            _statusLabel.text = kReleaseToRefresh;
            
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = 0;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case RefreshStateNormal:
        {
			_statusLabel.text = kPullToRefresh;
            
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = 0;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
        case RefreshStateRefreshing:
        {
            _statusLabel.text = kRefreshing;
            
            [UIView animateWithDuration:0.2 animations:^{
                // 1. add edge inset on top by 65
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = self.frame.origin.y - _scrollView.contentSize.height +kViewHeight;
                _scrollView.contentInset = inset;
                
                // 2. set content offset
                _scrollView.contentOffset = CGPointMake(0, self.validY + kViewHeight);
            }];
			break;
        }
	}
}

#pragma mark - used in super class
// valid y value
- (CGFloat)validY
{
    return MAX(_scrollView.contentSize.height, _scrollView.frame.size.height) - _scrollView.frame.size.height;
}

// view type
- (int)viewType
{
    return RefreshViewTypeFooter;
}
@end