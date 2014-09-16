//
//  StatusDetailController.m
//  ChineseTwitterClone
//
//  Created by wilson on 9/5/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#import "StatusDetailController.h"
#import "StatusDetailCell.h"
#import "StatusDetailCellFrame.h"
#import "DetailHeader.h"
#import "StatusTool.h"
#import "Status.h"
#import "CommentCellFrame.h"
#import "RepostCellFrame.h"
#import "Comment.h"
#import "RepostCell.h"
#import "CommentCell.h"
#import "MJRefresh.h"
#import "BaseText.h"
#import "BaseTextCellFrame.h"


@interface StatusDetailController () <DetailHeaderDelegate, MJRefreshBaseViewDelegate>
{
    StatusDetailCellFrame *_detailFrame;
    NSMutableArray *_repostFrames;
    NSMutableArray *_commentFrames;
    
    DetailHeader *_detailHeader;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL _isCommentLastPage;
    BOOL _isRepostLastPage;
}
@end

@implementation StatusDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweet Detail";
    self.view.backgroundColor = kGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // set table bottom margin
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTableBorderWidth, 0);
    
    _detailFrame = [[StatusDetailCellFrame alloc] init];
    _detailFrame.status = _status;
    
    _repostFrames = [NSMutableArray array];
    _commentFrames = [NSMutableArray array];
    
    // add pull up load
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.delegate = self;
    footer.hidden = YES;
    _footer = footer;
    
    // add pull down refreshing
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.tableView;
    _header.delegate = self;
    
    // add pull up loading
    _detailHeader = [DetailHeader header];
    _detailHeader.delegate = self;
    
    // "comment" is selected by default
    [self detailHeader:nil btnClick:kDetailHeaderBtnTypeComment];
}

#pragma mark get array that needs to be used
- (NSMutableArray *)currentFrames
{
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        return _commentFrames;
    } else {
        return _repostFrames;
    }
}

#pragma mark - datasource
#pragma mark number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [[self currentFrames] count];
    }
}

#pragma mark number of secionts
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 1. determine whether to show pull up control
    if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeComment) {
        _footer.hidden = _isCommentLastPage;
    } else if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
        _footer.hidden = _isRepostLastPage;
    }
    
    return 2;
}

#pragma mark cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // tweet detail cell
        static NSString *CellIdentifier = @"DetailCell";
        StatusDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[StatusDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.cellFrame = _detailFrame;
        return cell;
    } else if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
        // repost cell
        static NSString *CellIdentifier = @"RepostCell";
        RepostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[RepostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _repostFrames[indexPath.row];
        return cell;
    } else {
        // comment cell
        static NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.myTableView = tableView;
        }
        
        cell.indexPath = indexPath;
        cell.cellFrame = _commentFrames[indexPath.row];
        return cell;
    }
}

#pragma mark should highlight row at index path
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section != 0;
}

#pragma mark view for header in section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    _detailHeader.status = _status;
    return _detailHeader;
}

#pragma mark height for header in section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 60 : 0;
}

#pragma mark height for row at index path
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _detailFrame.cellHeight;
    } else {
        return [[self currentFrames][indexPath.row] cellHeight];
    }
}

#pragma mark - DetailHeaderDelegate
- (void)detailHeader:(DetailHeader *)header btnClick:(int)index
{
    // refresh table immediately in case of network latancy
    [self.tableView reloadData];
    
    if (index == kDetailHeaderBtnTypeRepost) {
        [self loadNewRepost];
    } else if (index == kDetailHeaderBtnTypeComment) {
        [self loadNewComment];
    }
}

#pragma mark load new repost
- (void)loadNewRepost
{
    long long firstID = 0;
    if (_repostFrames.count) {
        firstID = [[_repostFrames[0] baseText] ID];
    }
    
    [StatusTool repostsWithSinceId:firstID maxId:0 statusId:_status.ID success:^(NSArray *reposts, int totalNum, long long nextCursor) {
        
        // 1. get latest repost frames
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
        
        _status.repostsCount = totalNum;
        
        // 2. add data to the head of array
        [_repostFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _isRepostLastPage = (nextCursor == 0);
        
        // 3. refresh table
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark load new comment
- (void)loadNewComment
{
    long long firstID = 0;
    if (_commentFrames.count) {
        firstID = [[_commentFrames[0] baseText] ID];
    }
    
    [StatusTool commentsWithSinceId:firstID maxId:0 statusId:_status.ID success:^(NSArray *comments, int totalNum, long long nextCursor) {
        // 1. get latest comment frames
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
        
        // update the current tweet
        _status.commentsCount = totalNum;
        
        // 2. add data to the head of array
        [_commentFrames insertObjects:newFrames atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newFrames.count)]];
        
        _isCommentLastPage = (nextCursor == 0);
        
        // 3. refresh table
        [self.tableView reloadData];
    } failure:nil];
}

#pragma mark load more repost
- (void)loadMoreRepost
{
    long long lastId = [[[_repostFrames lastObject] baseText] ID] - 1;
    
    [StatusTool repostsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *reposts, int totalNum, long long nextCursor) {
        // 1. get latest comment frames
        NSMutableArray *newFrames = [self framesWithModels:reposts class:[RepostCellFrame class]];
        
        // update the current tweet
        _status.repostsCount = totalNum;
        
        // 2. add data
        [_repostFrames addObjectsFromArray:newFrames];
        
        _isRepostLastPage = (nextCursor == 0);
        
        // 3. refresh table
        [self.tableView reloadData];
        
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        [_footer endRefreshing];
    }];
}

#pragma mark load more comment
- (void)loadMoreComment
{
    long long lastId = [[[_commentFrames lastObject] baseText] ID] - 1;
    
    [StatusTool commentsWithSinceId:0 maxId:lastId statusId:_status.ID success:^(NSArray *comments, int totalNum, long long nextCursor) {
        // 1. get latest comment frames
        NSMutableArray *newFrames = [self framesWithModels:comments class:[CommentCellFrame class]];
        
        // update the current tweet
        _status.commentsCount = totalNum;
        
        // 2. add data 
        [_commentFrames addObjectsFromArray:newFrames];
        
        _isCommentLastPage = (nextCursor == 0);
        
        // 3. refresh table
        [self.tableView reloadData];
        
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        [_footer endRefreshing];
    }];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        // pull up to load more
        if (_detailHeader.currentBtnType == kDetailHeaderBtnTypeRepost) {
            [self loadMoreRepost];
        } else {
            [self loadMoreComment];
        }
    } else {
        // pull down to refresh
        [self loadNewStatus];
    }
}

#pragma mark load new tweet
- (void)loadNewStatus
{
    [StatusTool statusWithId:_status.ID success:^(Status *status) {
        _status = status;
        _detailFrame.status = status;
        
        [_header endRefreshing];
        // reload data
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [_header endRefreshing];
    }];
}

#pragma mark parse models into frames
- (NSMutableArray *)framesWithModels:(NSArray *)models class:(Class)class
{
    NSMutableArray *newFrames = [NSMutableArray array];
    for (BaseText *c in models) {
        BaseTextCellFrame *f = [[class alloc] init];
        f.baseText = c;
        [newFrames addObject:f];
    }
    
    return newFrames;
}

@end













