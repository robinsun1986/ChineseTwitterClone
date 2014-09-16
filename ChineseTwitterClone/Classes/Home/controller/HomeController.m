//
//  HomeController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "HomeController.h"
#import "UIBarButtonItem+Addition.h"
#import "AccountTool.h"
#import "StatusTool.h"
#import "Status.h"
#import "User.h"
#import "UIImage+Addition.h"
#import "StatusCellFrame.h"
#import "StatusCell.h"
#import "MJRefresh.h"
#import "StatusDetailController.h"

@interface HomeController () <MJRefreshBaseViewDelegate>
{
    NSMutableArray *_statusesFrames;
}
@end

@implementation HomeController
kHideScrollBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. build UI
    [self buildUI];

    // 2. integrate refresh control
    [self addRefreshViews];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);

//    // using refresh control provided by apple offcial api
//    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
//    [self.tableView addSubview:refresh];
//    [refresh addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
}

//#pragma mark start refresh 
//- (void)startRefresh:(UIRefreshControl *)refresh
//{
//    // ID of first tweet
//    long long firstID = [[_statusesFrames[0] status] ID];
//    
//    [StatusTool statusesWithSinceId:firstID maxId:0 success:^(NSArray *statuses) {
//        // 1. work out the frame when new tweet is loaded
//        NSMutableArray *newFrames = [NSMutableArray array];
//        for (Status *s in statuses) {
//            StatusCellFrame *f = [[StatusCellFrame alloc] init];
//            f.status = s;
//            [newFrames addObject:f];
//        }
//        // 2. add all elements in newFrames into the front of existing data
//        [_statusesFrames insertObjects:newFrames atIndexes:[NSIndexSet
//            indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
//        
//        // 3. reload data: re-call datasource method- numberOfRowsInSecion, cellForRowAtIndexPath
//        [self.tableView reloadData];
//        
//        // 4. end refreshing
//        [refresh endRefreshing];
//        
//    } failure:^(NSError *error) {
//        MyLog(@"%@", error.localizedDescription);
//    }];
//}

#pragma mark add refresh views
- (void)addRefreshViews
{
    _statusesFrames = [NSMutableArray array];
    
    // 1. pull down refresh
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.delegate = self;
    [header beginRefreshing];
    
    // 2. pull up load
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
//    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//        // pull up to load
//        MyLog(@"pull up to load ---- block");
//    };
    footer.delegate = self;
}

#pragma mark refresh delegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // pull up to load
        [self loadMoreData:refreshView];
    } else {
        // pull down to refresh
        [self loadNewData:refreshView];
    }
}

#pragma mark load more data
- (void)loadMoreData:(MJRefreshBaseView *)refreshView
{
    long long lastID = 0;
    
    if (_statusesFrames.count) {
        StatusCellFrame *scf = [_statusesFrames lastObject];
        lastID = scf.status.ID;
    }
    
    [StatusTool statusesWithSinceId:0 maxId:lastID success:^(NSArray *statuses) {
        // 1. work out the frame when new tweet is loaded
        NSMutableArray *newFrames = [NSMutableArray array];
        for (Status *s in statuses) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        // 2. add all elements in newFrames into the rear of existing data
        [_statusesFrames addObjectsFromArray:newFrames];
        
        // 3. reload data: re-call datasource method- numberOfRowsInSecion, cellForRowAtIndexPath
        [self.tableView reloadData];
        
        // 4. end refreshing
        [refreshView endRefreshing];
        
    } failure:^(NSError *error) {
        MyLog(@"%@", error.localizedDescription);
        // end refreshing
        [refreshView endRefreshing];
    }];
}

#pragma mark load new data
- (void)loadNewData:(MJRefreshBaseView *)refreshView
{
    long long firstID = 0;
    
    if (_statusesFrames.count) {
        StatusCellFrame *scf = _statusesFrames[0];
        firstID = scf.status.ID;
    }
    
    [StatusTool statusesWithSinceId:firstID maxId:0 success:^(NSArray *statuses) {
        // 1. work out the frame when new tweet is loaded
        NSMutableArray *newFrames = [NSMutableArray array];
        for (Status *s in statuses) {
            StatusCellFrame *f = [[StatusCellFrame alloc] init];
            f.status = s;
            [newFrames addObject:f];
        }
        // 2. add all elements in newFrames into the front of existing data
        [_statusesFrames insertObjects:newFrames atIndexes:[NSIndexSet
                                                            indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        // 3. reload data: re-call datasource method- numberOfRowsInSecion, cellForRowAtIndexPath
        [self.tableView reloadData];
        
        // 4. end refreshing
        [refreshView endRefreshing];
        
        // 5. show new tweet count at the top
        [self showNewStatusCount:statuses.count];
        
    } failure:^(NSError *error) {
        MyLog(@"%@", error.localizedDescription);
        // end refreshing
        [refreshView endRefreshing];
    }];
}

#pragma mark show new status count
- (void)showNewStatusCount:(int)count
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.enabled = NO;
    btn.adjustsImageWhenDisabled = NO;
    [btn setBackgroundImage:[UIImage resizedImage:@"timeline_new_status_background.png"] forState:UIControlStateNormal];
    CGFloat w = self.view.frame.size.width;
    CGFloat h = 35;
    btn.frame = CGRectMake(0, 44, w, h);
    NSString *title = count ? [NSString stringWithFormat:@"%d new tweet(s)", count] : @"No new tweet";
    [btn setTitle:title forState:UIControlStateNormal];

    // start animation
    CGFloat duration = 0.5;
    btn.transform = CGAffineTransformMakeTranslation(0, -h);
    [UIView animateWithDuration:duration animations:^{
        
        btn.transform = CGAffineTransformIdentity;
        
//        CGRect frame = btn.frame;
//        // height of navigation bar is 44
//        frame.origin.y = 44;
//        btn.frame = frame;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:duration delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            btn.transform = CGAffineTransformMakeTranslation(0, -h);
            
//            CGRect frame = btn.frame;
//            // height of navigation bar is 44
//            frame.origin.y = 44 - h;
//            btn.frame = frame;
        } completion:^(BOOL finished) {
            [btn removeFromSuperview];
        }];
        
    }];
    
    // add label below the navigation bar
    [self.navigationController.view insertSubview:btn belowSubview:self.navigationController.navigationBar];
    //MyLog(@"%d", count);
}

#pragma mark build UI
- (void)buildUI
{
    // title
    self.title = @"Home";
    
    // left bar button
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_compose.png" highlightedIcon:@"navigationbar_compose_highlighted.png" target:self action:@selector(sendStatus)];
    
    // right bar button
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigationbar_pop.png" highlightedIcon:@"navigationbar_pop_highlighted.png" target:self action:@selector(popMenu)];

    self.tableView.backgroundColor = kGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark create tweet
- (void)sendStatus
{
    MyLog(@"create tweet");
}

#pragma mark pop menu
- (void)popMenu
{
    MyLog(@"pop menu");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statusesFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[StatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
//    StatusCellFrame *f = [[StatusCellFrame alloc] init];
//    f.status = _statusesFrames[indexPath.row];
//    cell.statusCellFrame = f;
    cell.cellFrame = _statusesFrames[indexPath.row];

    return cell;
}

#pragma mark - tableview delegate
#pragma mark return the height for one row, called every time tableview is reloaded
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    StatusCellFrame *f = [[StatusCellFrame alloc] init];
//    f.status = _statusesFrames[indexPath.row];
//    return f.cellHeight;
    return  [_statusesFrames[indexPath.row] cellHeight];
}

#pragma mark observe cell tap
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusDetailController *detail = [[StatusDetailController alloc] init];
    StatusCellFrame *f = _statusesFrames[indexPath.row];
    detail.status = f.status;
    [self.navigationController pushViewController:detail animated:YES];
}

@end









