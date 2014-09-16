//
//  MJRefreshBaseView.h
//  
//  Created by mj on 13-3-4.
//  Copyright (c) 2013 All rights reserved.


// if this macro is defined, audio is needed
// dependent on AVFoundation.framework & AudioToolbox.framework
#define NeedAudio

// view height
#define kViewHeight 65.0

//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum {
	RefreshStatePulling = 1,
	RefreshStateNormal = 2,
	RefreshStateRefreshing = 3
} RefreshState;

typedef enum {
    RefreshViewTypeHeader = -1,
    RefreshViewTypeFooter = 1
} RefreshViewType;

@class MJRefreshBaseView;

typedef void (^BeginRefreshingBlock)(MJRefreshBaseView *refreshView);

@protocol MJRefreshBaseViewDelegate <NSObject>
@optional
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
@end

@interface MJRefreshBaseView : UIView
{
    // parent controller
    __weak UIScrollView *_scrollView;
    // delegate
    __weak id<MJRefreshBaseViewDelegate> _delegate;
    // callback
    BeginRefreshingBlock _beginRefreshingBlock;
    
    // child controller
    __weak UILabel *_lastUpdateTimeLabel;
	__weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
	__weak UIActivityIndicatorView *_activityView;
    
    // state
    RefreshState _state;

#ifdef NeedAudio
    // sound
    SystemSoundID _normalId;
    SystemSoundID _pullId;
    SystemSoundID _refreshingId;
    SystemSoundID _endRefreshId;
#endif
}

// constructor
- (id)initWithScrollView:(UIScrollView *)scrollView;

// child controllers
@property (nonatomic, weak, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, weak, readonly) UIImageView *arrowImage;

// callback
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
// delegate
@property (nonatomic, weak) id<MJRefreshBaseViewDelegate> delegate;
// parent view
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

// refreshing flag
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
// start refreshing
- (void)beginRefreshing;
// end refreshing
- (void)endRefreshing;
// free resources
- (void)free;

// to be implemented by subclass
- (void)setState:(RefreshState)state;
@end
