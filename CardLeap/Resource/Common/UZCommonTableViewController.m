//
//  UZCommonTableViewController.m
//
//  Created by mac on 13-12-18.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "UZCommonTableViewController.h"

@interface UZCommonTableViewController ()

@property (strong, nonatomic) UIView *mark;
@property (nonatomic)         BOOL    refreshing ;

@end

@implementation UZCommonTableViewController


#pragma mark - Refresh and load actions
- (void)refreshAction{
    self.page = 1;
}

- (void)loadMoreAction{
    
    self.page ++ ;
    [self showMark:@"努力加载中~"];
}

- (BOOL)checkBottomFrom:(NSInteger)arrayCount maxCount:(NSInteger)maxCount
{
    if (arrayCount >= maxCount) {
        [self loadMoreAction];
        return YES;
    }
    else{
        [self noMoreData];
        return NO;
    }
}

- (void)noMoreData
{
    [self showMark:@"最后一页了哦!"];
    [self performSelector:@selector(dismissMark) withObject:nil afterDelay:1.0];
}

#pragma mark - marks
// 加载之后的遮罩提示，可以优化（待续）
- (void)showMark:(NSString *)markMessage
{
    [self getTheMark:markMessage];
    
    [self fadeIn:self.mark andAnimationDuration:0.7 andWait:NO];
}

- (void)dismissMark
{
    [self fadeOut:self.mark andAnimationDuration:0.5 andWait:NO];
}

- (void)getTheMark:(NSString *)markMessage
{
    UIView *mark = [[UIView alloc] init];
    mark.frame = CGRectMake(0, 0, 140, 40);
    mark.center = CGPointMake(160, self.tableView.contentSize.height-40);
    mark.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 40)];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = markMessage;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14.0];
    [mark addSubview:label];
    mark.layer.cornerRadius = 3;
    
    self.mark = mark;
    
    [self.view addSubview:self.mark];
}

- (void)fadeIn: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait{
    __block BOOL done = wait;
    [view setAlpha:0.0];
    [UIView animateWithDuration:duration animations:^{
        [view setAlpha:1.0];
    } completion:^(BOOL finished) {
        done = NO;
    }];
    
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}
- (void)fadeOut: (UIView *)view andAnimationDuration: (float) duration andWait:(BOOL) wait{
    __block BOOL done = wait;
    [view setAlpha:1.0];
    [UIView animateWithDuration:duration animations:^{
        [view setAlpha:0.0];
    } completion:^(BOOL finished) {
        done = NO;
    }];
    
    while (done == YES)
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
}

#pragma mark - Refresh Control
- (void)addRefreshTableViewHeaderToTableView:(UITableView *)tableView
{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refresh addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (IBAction)refreshTableView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中……"];
        [self refreshAction];
//        [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
    }
}

- (void)refreshComplete
{
    [self.refreshControl endRefreshing];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd, h:mm:ss a"];
    NSString *lastUpdated =
        [NSString stringWithFormat:@"最后更新 %@", [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

#pragma mark - Functions


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [self.UZTableViewDatasource UZNumberOfSectionsInTableView:tableView];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.UZTableViewDatasource UZTableView:tableView numberOfRowsInSection:section];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
//    return [self.UZTableViewDatasource UZTableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate


#pragma mark - Lifecycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.page = 1;
    
    [self addRefreshTableViewHeaderToTableView:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
