//
//  myGroupListViewController.m
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myGroupListViewController.h"
#import "CateButtonView.h"
#import "UIScrollView+MJRefresh.h"
#import "myGroupInfo.h"
#import "myGroupTableViewCell.h"
#import "myGroupDetailViewController.h"
#import "GroupReviewViewController.h"
#import "myGroupSpikeCodeViewController.h"
#import "payAlipayWebViewController.h"
#import "UpdateGroupViewController.h"

@interface myGroupListViewController ()<UITableViewDataSource,UITableViewDelegate,
                                        cateButtonDelegate,myGroupCellDelegate,
                                        GroupRefreshDelegate,completeDelegate>
{
    NSMutableArray *myGroupArray;//我的团购列表
    NSString *cate_id;//分类id
    int page ;//分页
}
@property (strong,nonatomic)UITableView *myGroupTableview;
@end

@implementation myGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self.myGroupTableview headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
}

#pragma mark-----set UI
-(void)setUI
{
    [self setCateButton];
    [self.view addSubview:self.myGroupTableview];
    [_myGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [_myGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_myGroupTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_myGroupTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
    if ([_myGroupTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myGroupTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_myGroupTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myGroupTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

#pragma mark-----设置分类按钮
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"未付款",@"未消费",@"待评价",@"退款"];
    NSArray *tagArray = @[@"0",@"1",@"2",@"3",@"4"];
    
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

#pragma mark-----init data
-(void)initData
{
    myGroupArray  = [[NSMutableArray alloc] init ];
    cate_id = @"0";
    page = 1;
}

#pragma mark-----get data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"my_group");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"status":cate_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            if(page == 1)
            {
                [myGroupArray removeAllObjects];
            }
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                myGroupInfo *info = [[myGroupInfo alloc]initWithDictionary:dic];
                [myGroupArray addObject:info];
            }
            [self.myGroupTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.myGroupTableview headerEndRefreshing];
        [self.myGroupTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
        [self.myGroupTableview headerEndRefreshing];
        [self.myGroupTableview footerEndRefreshing];
    }];
}

#pragma mark-----get UI
-(UITableView *)myGroupTableview
{
    if (!_myGroupTableview) {
        _myGroupTableview = [[UITableView alloc] initForAutoLayout];
        _myGroupTableview.delegate = self;
        _myGroupTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_myGroupTableview];
        [_myGroupTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_myGroupTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _myGroupTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _myGroupTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _myGroupTableview.footerRefreshingText = @"正在更新数据";
        _myGroupTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _myGroupTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _myGroupTableview.headerRefreshingText = @"马上回来";
        if ([_myGroupTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myGroupTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myGroupTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myGroupTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myGroupTableview;
}

#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    myGroupInfo *info = [myGroupArray objectAtIndex:indexPath.row];
    if ([info.status integerValue] == 1) {
        myGroupSpikeCodeViewController *firVC = [[myGroupSpikeCodeViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"团购成功" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"团购成功"];
        firVC.info = info;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        myGroupDetailViewController *firVC = [[myGroupDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"订单详情" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"订单详情"];
        firVC.info = info;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_group_cell";
    myGroupTableViewCell *cell=(myGroupTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    myGroupInfo *info = [myGroupArray objectAtIndex:indexPath.row];
    [cell configureCell:info row:indexPath.row];
    cell.delegate = self;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myGroupArray count];
}


#pragma mark------refresh aciton
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"加载更多");
    page++;
    [self getDataFromNet];
}

-(void)myOperation:(NSInteger)index row:(NSInteger)row
{
    if (index == 0) {
        //支付---
        myGroupInfo *info = [myGroupArray objectAtIndex:row];
        UpdateGroupViewController *firVC = [[UpdateGroupViewController alloc] init];
        [firVC setNavBarTitle:@"提交订单" withFont:14.0f];
        firVC.myUpdateInfo = info;
        [self.navigationController pushViewController:firVC animated:YES];
        
    }else if (index == 2){
        //评价----
        GroupReviewViewController *firVC = [[GroupReviewViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"团购评价" withFont:14.0f];
        myGroupInfo *info = [myGroupArray objectAtIndex:row];
        firVC.info = info;
        firVC.delegate = self;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(void)refreshAction
{
    [self.myGroupTableview headerBeginRefreshing];
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
