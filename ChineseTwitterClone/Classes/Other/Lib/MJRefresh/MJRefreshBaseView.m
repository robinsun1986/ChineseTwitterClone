//
//  MJRefreshBaseView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013 All rights reserved.
//

#import "MJRefreshBaseView.h"

#define kBundleName @"MJRefresh.bundle"
#define kSrcName(file) [kBundleName stringByAppendingPathComponent:file]

@interface  MJRefreshBaseView()
// valid y value
- (CGFloat)validY;
// view type
- (int)viewType;
@end

@implementation MJRefreshBaseView

#pragma mark - init
- (id)initWithScrollView:(UIScrollView *)scrollView
{
    if (self = [super init]) {
        self.scrollView = scrollView;
    }
    return self;
}

#pragma mark initialization
- (void)initial
{
    // 1.self properties
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    // 2. label for last update time
    [self addSubview:_lastUpdateTimeLabel = [self labelWithFontSize:12]];
    
    // 3. status label
    [self addSubview:_statusLabel = [self labelWithFontSize:13]];
    
    // 4. arrow image
    UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSrcName(@"arrow.png")]];
    arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_arrowImage = arrowImage];
    
    // 5. indicator
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.bounds = arrowImage.bounds;
    activityView.autoresizingMask = arrowImage.autoresizingMask;
    [self addSubview:_activityView = activityView];
    
    // 6. set default state
    [self setState:RefreshStateNormal];
    
#ifdef NeedAudio
    // 7. load audio
    _pullId = [self loadId:@"pull.wav"];
    _normalId = [self loadId:@"normal.wav"];
    _refreshingId = [self loadId:@"refreshing.wav"];
    _endRefreshId = [self loadId:@"end_refreshing.wav"];
#endif
}

#pragma mark constructor
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initial];
    }
    return self;
}

#pragma mark create an UILabel
- (UILabel *)labelWithFontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc] init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:size];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#ifdef NeedAudio  
#pragma mark load sound id
- (SystemSoundID)loadId:(NSString *)filename
{
    SystemSoundID ID;
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:kSrcName(filename) withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    return ID;
}
#endif

#pragma mark set frame
- (void)setFrame:(CGRect)frame
{
    frame.size.height = kViewHeight;
    [super setFrame:frame];
    
    CGFloat statusY = 5;
    CGFloat w = frame.size.width;
    if (w == 0 || _statusLabel.frame.origin.y == statusY) return;
    
    // 1. status label
    CGFloat statusX = 0;
    CGFloat statusHeight = 20;
    CGFloat statusWidth = w;
    _statusLabel.frame = CGRectMake(statusX, statusY, statusWidth, statusHeight);
    
    // 2. label for last update time
    CGFloat lastUpdateY = statusY + statusHeight + 5;
    _lastUpdateTimeLabel.frame = CGRectMake(statusX, lastUpdateY, statusWidth, statusHeight);
    
    // 3. arrow
    CGFloat arrowX = w * 0.5 - 100;
    _arrowImage.center = CGPointMake(arrowX, frame.size.height * 0.5);
    
    // 4. indicator
    _activityView.center = _arrowImage.center;
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [super removeFromSuperview];
}

#pragma mark - UIScrollView related
#pragma mark set UIScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    // remove old observer
    [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    // set scrollView
    _scrollView = scrollView;
    [_scrollView addSubview:self];
    // observe contentOffset
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark observe UIScrollView contentOffset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{    
    if ([@"contentOffset" isEqualToString:keyPath]) {
        CGFloat offsetY = _scrollView.contentOffset.y * self.viewType;
        CGFloat validY = self.validY;
        if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden
            || _state == RefreshStateRefreshing
            || offsetY <= validY) return;
        
        // ready to refresh && release
        if (_scrollView.isDragging) {
            CGFloat validOffsetY = validY + kViewHeight;
            if (_state == RefreshStatePulling && offsetY <= validOffsetY) {
                // turn to normal
#ifdef NeedAudio
                AudioServicesPlaySystemSound(_normalId);
#endif
                [self setState:RefreshStateNormal];
            } else if (_state == RefreshStateNormal && offsetY > validOffsetY) {
                // turn to ready for refreshing
#ifdef NeedAudio
                AudioServicesPlaySystemSound(_pullId);
#endif
                [self setState:RefreshStatePulling];
            }
        } else {
            if (_state == RefreshStatePulling) {
                // start refreshing
#ifdef NeedAudio
                AudioServicesPlaySystemSound(_refreshingId);
#endif
                [self setState:RefreshStateRefreshing];
            }
        }
    }
}

#pragma mark set state
- (void)setState:(RefreshState)state
{
    switch (state) {
		case RefreshStateNormal:
            _arrowImage.hidden = NO;
			[_activityView stopAnimating];
			break;
            
        case RefreshStatePulling:
            break;
            
		case RefreshStateRefreshing:
			[_activityView startAnimating];
			_arrowImage.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            
            // notify delegate
            if ([_delegate respondsToSelector:@selector(refreshViewBeginRefreshing:)]) {
                [_delegate refreshViewBeginRefreshing:self];
            }
            
            // call back
            if (_beginRefreshingBlock) {
                _beginRefreshingBlock(self);
            }
			break;
	}
}

#pragma mark - Status related
#pragma mark check whether its refreshing
- (BOOL)isRefreshing
{
    return RefreshStateRefreshing == _state;
}
#pragma mark begin refreshing
- (void)beginRefreshing
{
    [self setState:RefreshStateRefreshing];
}
#pragma mark end refreshing
- (void)endRefreshing
{
    [self setState:RefreshStateNormal];
}
@end