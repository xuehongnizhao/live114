//
//  myOrderRoomStatusViewController.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderRoomStatusViewController.h"
#import "orderRoomReviewViewController.h"
#import "myOrderRoomStatusTableViewCell.h"
#import "orderRoomDetailViewController.h"

@interface myOrderRoomStatusViewController ()<UITableViewDataSource,UITableViewDelegate,orderRoomRefreshDelegate,myOrderRoomStatusDelegate>
@property (strong,nonatomic)UITableView *myOrderRoomTableview;//订酒店详细信息列表
@end

@implementation myOrderRoomStatusViewController

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
    [self.view addSubview:self.myOrderRoomTableview];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark---------get UI
-(UITableView *)myOrderRoomTableview
{
    if (!_myOrderRoomTableview) {
        _myOrderRoomTableview = [[UITableView alloc] initForAutoLayout];
        _myOrderRoomTableview.delegate = self;
        _myOrderRoomTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_myOrderRoomTableview];
        if ([_myOrderRoomTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myOrderRoomTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myOrderRoomTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myOrderRoomTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myOrderRoomTableview;
}

#pragma mark---------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    NSInteger section = indexPath.section;
    if (section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"访问商家-----");
            orderRoomDetailViewController *firVC = [[orderRoomDetailViewController alloc] init];
            [firVC setNavBarTitle:@"如e商家" withFont:14.0f];
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
    static NSString *simpleTableIdentifier=@"order_room_status_cell";
    myOrderRoomStatusTableViewCell *cell=(myOrderRoomStatusTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myOrderRoomStatusTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    [cell confirgureCell:self.info row:indexPath.row section:indexPath.section];
    cell.delegate = self;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
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

-(void)orderRoomRefreshAction
{
    NSLog(@"刷新");
    self.info.seat_status = @"4";
    [self.myOrderRoomTableview reloadData];
}

-(void)go2RoomReviewAction
{
    NSLog(@"去评价");
    orderRoomReviewViewController *firVC = [[orderRoomReviewViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"评价" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"评价"];
    firVC.shop_id = self.info.shop_id;
    firVC.hotel_id = self.info.hotel_id;
    firVC.delegate = self;
    [self.navigationController pushViewController:firVC animated:YES];
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
