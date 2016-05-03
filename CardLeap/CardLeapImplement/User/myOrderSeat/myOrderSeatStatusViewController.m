//
//  myOrderSeatStatusViewController.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderSeatStatusViewController.h"
#import "myOrderSeatStatusTableViewCell.h"
#import "orderSeatReviewViewController.h"
#import "orderSeatDetailViewController.h"

@interface myOrderSeatStatusViewController ()<UITableViewDataSource,
                                                UITableViewDelegate,
                                                myOrderSeatStatusDelegate,
                                                refreshDelegate>
@property (strong,nonatomic)UITableView *myOrderSeatStatusTableview;//订座位详细信息列表
@end

@implementation myOrderSeatStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view addSubview:self.myOrderSeatStatusTableview];
    [_myOrderSeatStatusTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myOrderSeatStatusTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_myOrderSeatStatusTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myOrderSeatStatusTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark---------get UI
-(UITableView *)myOrderSeatStatusTableview
{
    if (!_myOrderSeatStatusTableview) {
        _myOrderSeatStatusTableview = [[UITableView alloc] initForAutoLayout];
        _myOrderSeatStatusTableview.delegate = self;
        _myOrderSeatStatusTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_myOrderSeatStatusTableview];
        _myOrderSeatStatusTableview.separatorInset = UIEdgeInsetsZero;
        [_myOrderSeatStatusTableview setScrollEnabled:NO];
        if ([_myOrderSeatStatusTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myOrderSeatStatusTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_myOrderSeatStatusTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myOrderSeatStatusTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myOrderSeatStatusTableview;
}

#pragma mark---------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    if (section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"访问商家-----");
            orderSeatDetailViewController *firVC = [[orderSeatDetailViewController alloc] init];
            [firVC setNavBarTitle:@"商家详情" withFont:14.0f];
            firVC.shop_id = self.info.shop_id;
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_seat_status_cell";
    myOrderSeatStatusTableViewCell *cell=(myOrderSeatStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myOrderSeatStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    [cell confirgureCell:self.info row:row section:section];
    cell.delegate = self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 5.0f;
}

#pragma mark----delegate
-(void)goReviewAction
{
    NSLog(@"去评价");
    orderSeatReviewViewController *firVC = [[orderSeatReviewViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"评价" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"评价"];
    firVC.shop_id = self.info.shop_id;
    firVC.seat_id = self.info.seat_id;
    firVC.delegate = self;
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark --- 2015.12.15 评价后跳转的页面可能要改,标记一下
-(void)refreshAction
{
    NSLog(@"更新数据");
    self.info.confirm_status = @"4";
    [self.myOrderSeatStatusTableview reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
