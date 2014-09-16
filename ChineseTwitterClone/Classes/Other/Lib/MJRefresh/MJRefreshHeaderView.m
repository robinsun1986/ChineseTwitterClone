//
//  MJRefreshHeaderView.m
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013. All rights reserved.
//  

#define kPullToRefresh @"Pull down to refresh"
#define kReleaseToRefresh @"Release to refresh"
#define kRefreshing @"Loading..."

#define kTimeKey @"MJRefreshHeaderView"

#import "MJRefreshHeaderView.h"

@interface MJRefreshHeaderView()
// last update time
@property (nonatomic, strong) NSDate *lastUpdateTime;
@end

@implementation MJRefreshHeaderView

+ (id)header
{
    return [[MJRefreshHeaderView alloc] init];
}

#pragma mark - UIScrollView related
#pragma mark override to configure ScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    
    // set frame
    self.frame = CGRectMake(0, -kViewHeight, scrollView.frame.size.width, kViewHeight);
    
    // last update time
    _lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeKey];
    
    // update time label
    [self updateTimeLabel];
}

#pragma mark - state related
#pragma mark set last update time
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // archive
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:kTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // update time label
    [self updateTimeLabel];
}

#pragma mark update time label
- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;
    
    // 1. get year, month, date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2. format date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // today
        formatter.dateFormat = @"Today HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // this year
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateTime];
    
    // 3. set label text
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"Last update: %@", time];
}

#pragma mark set state
- (void)setState:(RefreshState)state
{
    if (_state == state) return;
    
    [super setState:state];
    
    // store old state
    RefreshState oldState = _state;
    
	switch (_state = state) {
		case RefreshStatePulling:
        {
            _statusLabel.text = kReleaseToRefresh;
            
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = 0;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case RefreshStateNormal:
        {
			_statusLabel.text = kPullToRefresh;
            
            // finish refreshing
            if (oldState == RefreshStateRefreshing) {
                // save last update time
                self.lastUpdateTime = [NSDate date];
#ifdef NeedAudio
                AudioServicesPlaySystemSound(_endRefreshId);
#endif     
            }
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = 0;
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
                inset.top = kViewHeight;
                _scrollView.contentInset = inset;
                // 2. set content offset
                _scrollView.contentOffset = CGPointMake(0, -kViewHeight);
            }];
			break;
        }
	}
}

#pragma mark - used in super class
// valid y value
- (CGFloat)validY
{
    return 0;
}

// view type
- (int)viewType
{
    return RefreshViewTypeHeader;
}
@end