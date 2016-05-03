//
//  myOrderSeatCenterViewController.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderSeatCenterViewController.h"
#import "CateButtonView.h"
#import "UIScrollView+MJRefresh.h"
#import "myOrderSeatCenterInfo.h"
#import "myOrderSeatCenterTableViewCell.h"
#import "mySeatSuccessViewController.h"
#import "orderSeatReviewViewController.h"
#import "myOrderSeatStatusViewController.h"

@interface myOrderSeatCenterViewController ()<cateButtonDelegate,UITableViewDataSource,UITableViewDelegate,buttonActionDelegate,refreshDelegate>
{
    NSMutableArray *myOrderSeatArray;//我的外卖订单列表
    int page;//分页
    NSString *cate_id;//分类id
}
@property (strong,nonatomic)UITableView *myOrderSeatTableview;
@end

@implementation myOrderSeatCenterViewController

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
    [self.myOrderSeatTableview reloadData];
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
    [self.view addSubview:self.myOrderSeatTableview];
    [_myOrderSeatTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myOrderSeatTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_myOrderSeatTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myOrderSeatTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
//    [self getDataFromNet];
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_myOrderSeatTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
    [self getDataFromNet];
}
#pragma mark-----get UI
-(UITableView *)myOrderSeatTableview
{
    if (!_myOrderSeatTableview) {
        _myOrderSeatTableview = [[UITableView alloc] initForAutoLayout];
        _myOrderSeatTableview.delegate = self;
        _myOrderSeatTableview.dataSource = self;
        _myOrderSeatTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_myOrderSeatTableview];
        [_myOrderSeatTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_myOrderSeatTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _myOrderSeatTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _myOrderSeatTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _myOrderSeatTableview.footerRefreshingText = @"正在刷新";
        _myOrderSeatTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _myOrderSeatTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _myOrderSeatTableview.headerRefreshingText = @"马上回来";
        if ([_myOrderSeatTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myOrderSeatTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myOrderSeatTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myOrderSeatTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myOrderSeatTableview;
}
#pragma mark-----设置分类按钮
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"有效",@"待评价",@"失效"];
    NSArray *tagArray = @[@"0",@"2",@"3",@"1"];
    
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
    NSString *url = connect_url(@"my_seat");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"seat_status":cate_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"page":[NSString stringWithFormat:@"%d",page]
                           };
    NSLog(@"订座dict:%@",dict);
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            if (page == 1) {
                [myOrderSeatArray removeAllObjects];
            }
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                myOrderSeatCenterInfo *info = [[myOrderSeatCenterInfo alloc] initWithDictionary:dic];
                [myOrderSeatArray addObject:info];
            }
            [self.myOrderSeatTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.myOrderSeatTableview footerEndRefreshing];
        [self.myOrderSeatTableview headerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"进入订单详情");
    myOrderSeatCenterInfo *info = [myOrderSeatArray objectAtIndex:indexPath.row];
    myOrderSeatStatusViewController *firVC = [[myOrderSeatStatusViewController alloc] init];
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
    static NSString *simpleTableIdentifier=@"my_order_seat_cell";
    myOrderSeatCenterTableViewCell *cell=(myOrderSeatCenterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myOrderSeatCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    myOrderSeatCenterInfo *info = [myOrderSeatArray objectAtIndex:indexPath.row];
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

-(void)goToReviewDelegate:(NSInteger)tag
{
    
    myOrderSeatCenterInfo *info = [myOrderSeatArray objectAtIndex:tag];
    orderSeatReviewViewController *firVC = [[orderSeatReviewViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"评价" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"评价"];
    firVC.shop_id = info.shop_id;
    firVC.seat_id = info.seat_id;
    NSLog(@"去评价%ld。seat_id：%@   shop_id:%@",(long)tag,info.seat_id,info.shop_id);
    firVC.delegate = self;
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark-----refresh delegate
-(void)refreshAction
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
