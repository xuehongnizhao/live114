//
//  myOrderRoomCenterViewController.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderRoomCenterViewController.h"
#import "CateButtonView.h"
#import "UIScrollView+MJRefresh.h"
#import "myOrderRoomCenterInfo.h"
#import "myOrderRoomCenterTableViewCell.h"
#import "orderRoomReviewViewController.h"
#import "myOrderRoomStatusViewController.h"


@interface myOrderRoomCenterViewController ()<cateButtonDelegate,UITableViewDataSource,UITableViewDelegate,orderRoomActionDelegate,orderRoomRefreshDelegate>
{
    NSMutableArray *myOrderSeatArray;//订酒店数据数组
    int page;//分类
    NSString *cate_id;//分类id
}
@property (strong,nonatomic)UITableView *myOrderRoomTableview;
@end

@implementation myOrderRoomCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.myOrderRoomTableview reloadData];
}

#pragma mark-----initData
-(void)initData
{
    page = 1;
    cate_id = @"0";
    myOrderSeatArray = [[NSMutableArray alloc] init];
}

#pragma mark-----set UI
-(void)setUI
{
    [self setCateButton];
    [self.view addSubview:self.myOrderRoomTableview];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myOrderRoomTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_myOrderRoomTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
    [self getDataFromNet];
}

#pragma mark-----get UI
-(UITableView *)myOrderRoomTableview
{
    if (!_myOrderRoomTableview) {
        _myOrderRoomTableview = [[UITableView alloc] initForAutoLayout];
        _myOrderRoomTableview.delegate = self;
        _myOrderRoomTableview.dataSource = self;
        _myOrderRoomTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_myOrderRoomTableview];
        [_myOrderRoomTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_myOrderRoomTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _myOrderRoomTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _myOrderRoomTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _myOrderRoomTableview.footerRefreshingText = @"正在加载数据";
        _myOrderRoomTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _myOrderRoomTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _myOrderRoomTableview.headerRefreshingText = @"马上回来";
        if ([_myOrderRoomTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myOrderRoomTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myOrderRoomTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myOrderRoomTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myOrderRoomTableview;
}

#pragma mark-----设置分类按钮
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"有效",@"失效",@"待评价"];
    NSArray *tagArray = @[@"0",@"2",@"1",@"3"];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CateButtonView *cateView = [[CateButtonView alloc] initWithFrame:CGRectMake(5, 5, rect.size.width-10, 30) titleArray:titleArray tagArray:tagArray index:0];
    cateView.delegate = self;
    [cateView setIndex:0];
    [self.view addSubview:cateView];
}

#pragma mark------------cate delegate
-(void)chooseCateID:(NSInteger)cateID
{
    NSLog(@"do something");
    NSString *type = [NSString stringWithFormat:@"%ld",(long)cateID];
    NSLog(@"选择了分类%@",type);
    cate_id = type;
    page = 1;
    [self getDataFromNet];
}

#pragma mark---------get data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"my_hotel");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"hotel_status":cate_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"session_key":[UserModel shareInstance].session_key,
                           @"page":[NSString stringWithFormat:@"%d",page]
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            NSArray *arr = param[@"obj"];
            if (page ==  1) {
                [myOrderSeatArray removeAllObjects];
            }
            for (NSDictionary *dic in arr) {
                myOrderRoomCenterInfo *info = [[myOrderRoomCenterInfo alloc] initWithDictionary:dic];
                [myOrderSeatArray addObject:info];
            }
            [self.myOrderRoomTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.myOrderRoomTableview footerEndRefreshing];
        [self.myOrderRoomTableview
         headerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"进入订单详情");
    myOrderRoomCenterInfo *info = [myOrderSeatArray objectAtIndex:indexPath.row];
    myOrderRoomStatusViewController *firVC = [[myOrderRoomStatusViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:info.shop_name withFont:14.0f];
//    [firVC.navigationItem setTitle:info.shop_name];
    firVC.info = info;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_order_room_cell";
    myOrderRoomCenterTableViewCell *cell=(myOrderRoomCenterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myOrderRoomCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    myOrderRoomCenterInfo *info = [myOrderSeatArray objectAtIndex:indexPath.row];
    [cell confirgureCell:info row:indexPath.row];
    cell.delegate = self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myOrderSeatArray count];
}

#pragma mark-----refresh action
-(void)headerBeginRefreshing
{
    NSLog(@"刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"加载更多");
    page ++;
    [self getDataFromNet];
}

-(void)orderRoomAction:(NSInteger)row
{
    NSLog(@"评价的记录%ld",(long)row);
    myOrderRoomCenterInfo *info = [myOrderSeatArray objectAtIndex:row];
    orderRoomReviewViewController *firVC = [[orderRoomReviewViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"评价" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"评价"];
    firVC.shop_id = info.shop_id;
    firVC.hotel_id = info.hotel_id;
    firVC.delegate = self;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)orderRoomRefreshAction
{
    page = 1;
    [self getDataFromNet];
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
