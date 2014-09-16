//
//  MoreController.m
//  ChineseTwitterClone
//
//  Created by wilson on 8/27/14.
//  Copyright (c) 2014 robin.sun. All rights reserved.
//

#pragma mark logout button used only for more controller
@interface LogoutBtn : UIButton

@end

@implementation LogoutBtn
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat w = contentRect.size.width - 2 * x;
    CGFloat h = contentRect.size.height;
    return CGRectMake(x, y, w, h);
}
@end

#import "MoreController.h"
#import "UIImage+Addition.h"
#import "GroupCell.h"
#import "AccountsController.h"

@interface MoreController ()
{
    NSArray *_data;
}

@end

@implementation MoreController
kHideScrollBar

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. build UI
    [self buildUI];
    
    // 2. load plist
    [self loadPlist];
    
    // 3. set tableview properties
    [self buildTableView];
    
}

#pragma mark build table view
- (void)buildTableView
{
    // backgroundView has higher priority over backgroundColor 
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kGlobalBg;
    // 2. set header height for tableview
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    
    // 3. add a button after tableview
    LogoutBtn *logout = [LogoutBtn buttonWithType:UIButtonTypeCustom];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    
    // the width of footerview does not need to be set, by default it is equivalent to the width of tableview
    logout.bounds = CGRectMake(0, 0, 0, 44);
    // set button text
    [logout setTitle:@"Logout" forState:UIControlStateNormal];
    self.tableView.tableFooterView = logout;
    // add bottom inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

#pragma mark load Plist
- (void)loadPlist
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    _data = [NSArray arrayWithContentsOfURL:url];
}

#pragma mark build UI
- (void)buildUI
{
    self.title = @"More";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section == _data.count - 1) {
        height = 10;
    }
    
    return height;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}


- (void)setCell:(GroupCell *)cell accessoryWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2) {
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, 80, 44);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = ((indexPath.row == 1) ? @"Classic" : @"Image");
        label.font = [UIFont systemFontOfSize:12];
        cell.accessoryView = label;
    } else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow.png"]];
    }
}

#pragma mark called when a new cell enter the sight
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    // forIndexPath:indexPath is used with Storyboard
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.myTableView = tableView;
    }
    
    [self setCell:cell accessoryWithIndexPath:indexPath];

    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.textLabel.backgroundColor = [UIColor clearColor];

    // set cell background
    cell.indexPath = indexPath;
    
    // set cell type (what is displayed in the right)
    if (indexPath.section == 2) {
        cell.cellType = kCellTypeLabel;
        cell.rightLabel.text = (indexPath.row == 1) ? @"Classic" : @"Image";
    } else if (indexPath.section == 4) {
        cell.cellType = kCellTypeNone;
    } else {
        cell.cellType = kCellTypeArrow;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        AccountsController *accounts = [[AccountsController alloc] init];
        [self.navigationController pushViewController:accounts animated:YES];
    }
}

@end








