//
//  MySpikeListViewController.m
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "MySpikeListViewController.h"
#import "CateButtonView.h"
#import "UIScrollView+MJRefresh.h"
#import "mySpikeInfo.h"
#import "mySpikeTableViewCell.h"
#import "CouponDetailViewController.h"
#import "couponInfo.h"
#import "mySpikeChekCodeViewController.h"

@interface MySpikeListViewController ()<cateButtonDelegate,UITableViewDataSource,UITableViewDelegate,chooseDelegate,UIAlertViewDelegate>
{
    int page ;//page
    NSString *cate_id;//cat_id
    NSMutableArray *mySpikeArray;//优惠券数组
}
@property (strong, nonatomic) UITableView *mySpikeTableview;//列表
@property (strong, nonatomic) UIButton *deleteButton;//删除button
@end

@implementation MySpikeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
    [self getDataFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----设置分类按钮选择器
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"未使用",@"已使用",@"快到期",@"已过期"];
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

#pragma mark------------get Data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"my_spike");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"where":cate_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue] == 200) {
            if (page == 1) {
                [mySpikeArray removeAllObjects];
            }
            [SVProgressHUD dismiss];
            NSArray *arr = [param objectForKey:@"obj"];
            for (NSDictionary *dict in arr) {
                mySpikeInfo *info = [[mySpikeInfo alloc] initWithDictionary:dict];
                [mySpikeArray addObject:info];
            }
            [self.mySpikeTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.mySpikeTableview headerEndRefreshing];
        [self.mySpikeTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark------------init data
-(void)initData
{
    mySpikeArray = [[NSMutableArray alloc] init];
    page = 1;
    cate_id = @"0";
}

#pragma mark------------get UI
-(UITableView *)mySpikeTableview
{
    if (!_mySpikeTableview) {
        _mySpikeTableview = [[UITableView alloc] initForAutoLayout];
        _mySpikeTableview.delegate = self;
        _mySpikeTableview.dataSource = self;
        _mySpikeTableview.separatorInset=UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_mySpikeTableview];
        [_mySpikeTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_mySpikeTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _mySpikeTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _mySpikeTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _mySpikeTableview.footerRefreshingText = @"正在加载";
        _mySpikeTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _mySpikeTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _mySpikeTableview.headerRefreshingText = @"马上回来";
        if ([_mySpikeTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mySpikeTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_mySpikeTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mySpikeTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _mySpikeTableview;
}

-(UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initForAutoLayout];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.cornerRadius = 4.0f;
        _deleteButton.backgroundColor = UIColorFromRGB(0x75c3d0);
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

#pragma mark------------next page and refresh
-(void)headerBeginRefreshing
{
    NSLog(@"下拉刷新");
    page = 1;
    [self getDataFromNet];
}

-(void)footerBeginRefreshing
{
    NSLog(@"上拉加载更多");
    page++;
    [self getDataFromNet];
}

#pragma mark------------set UI
-(void)setUI
{
    [self setCateButton];
    
    [self.view addSubview:self.mySpikeTableview];
    //_mySpikeTableview.layer.borderWidth = 1;
    [_mySpikeTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_mySpikeTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_mySpikeTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    [_mySpikeTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50.0f];
    
    [self.view addSubview:self.deleteButton];
    [_deleteButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_deleteButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mySpikeTableview withOffset:5.0f];
    [_deleteButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
    
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_mySpikeTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
}

#pragma mark------------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"查看凭证");
  
    mySpikeInfo *info = [mySpikeArray objectAtIndex:indexPath.row];
    //未使用的跳转查看二维码 使用过的跳转商家详情
    if ([info.is_use integerValue] == 0) {
        mySpikeChekCodeViewController *firVC = [[mySpikeChekCodeViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:info.spike_name withFont:14.0f];
        firVC.info = info;
        firVC.spike_code = info.spike_code;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
        firVC.message_url  = info.message_url;
        firVC.share_url = info.share_url;
        [firVC setNavBarTitle:info.spike_name withFont:15.0f];
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    } 
 
//    CouponDetailViewController *firVC = [[CouponDetailViewController alloc] init];
//    [firVC setHiddenTabbar:YES];
//    firVC.message_url = info.message_url;
//    [firVC.navigationItem setTitle:info.spike_name];
//    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_spike_cell";
    mySpikeTableViewCell *cell=(mySpikeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[mySpikeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    mySpikeInfo *info = [mySpikeArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configureCell:info row:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mySpikeArray count];
}

#pragma mark------------delete action
-(void)deleteAction:(UIButton*)sender
{
#pragma mark --- 2015.12.29 当没有优惠券时，点击删除按钮，提示“没有优惠券”。"确认删除订单"文字改成"确认删除优惠券"。
    if (mySpikeArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"没有优惠券"];
        return;
    }
    NSLog(@"删除我的优惠券");
    //
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除优惠券" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma mark----------cell delegate
-(void)deleteMySpikeDelegate:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    mySpikeInfo *info = [mySpikeArray objectAtIndex:index];
    if ([info.is_delete integerValue]==0) {
        info.is_delete = @"1";
    }else{
        info.is_delete = @"0";
    }
    [self.mySpikeTableview reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *url = connect_url(@"my_spike_del");
        NSString *grab_id = @"";
        for (mySpikeInfo *info in mySpikeArray) {
            if ([info.is_delete integerValue]==1) {
                if(grab_id.length == 0){
                    grab_id = [NSString stringWithFormat:@"%@",info.spike_id];
                }else{
                    grab_id = [NSString stringWithFormat:@"%@,%@",grab_id,info.spike_id];
                }
            }
        }
        if (grab_id.length > 0) {
            NSDictionary *dict = @{
                                   @"app_key":url,
                                   @"u_id":[UserModel shareInstance].u_id,
                                   @"session_key":[UserModel shareInstance].session_key,
                                   @"grab_id":grab_id
                                   };
            [[LinLoadingView shareInstances:self.view] startAnimation];  //开始转动
            [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                if ([param[@"code"] integerValue]==200) {
                    [[LinLoadingView shareInstances:self.view] stopWithAnimation:[param objectForKey:@"message"]];  //停止转动
                    //[SVProgressHUD dismiss];
                    page = 1;
                    [self getDataFromNet];
                }else{
                    [[LinLoadingView shareInstances:self.view] stopWithAnimation:param[@"message"]];  //停止转动
                    //[SVProgressHUD showErrorWithStatus:param[@"message"]];
                }
            } andErrorBlock:^(NSError *error) {
                [[LinLoadingView shareInstances:self.view] stopWithAnimation:@"网络不给力"];  //停止转动
                //[SVProgressHUD showErrorWithStatus:@"网络异常"];
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小编提示" message:@"您还没有选择要删除的优惠券" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:@"取消", nil];
            [alert show];
        }

    }
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
