//
//  myOrderViewController.m
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myOrderViewController.h"
#import "CateButtonView.h"
#import "UIScrollView+MJRefresh.h"
#import "OrderDetailViewController.h"
#import "RviewDishListViewController.h"
#import "myOrderCenterInfo.h"
#import "myOrderCenterTableViewCell.h"
#import "LoginViewController.h"
//支付宝
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

@interface myOrderViewController ()<cateButtonDelegate,UITableViewDataSource,UITableViewDelegate,reviewDelegate>
{
    int page;//分页
    NSString *cate_id;//分类id
    NSMutableArray *myOrderArray;//订单数组
}
@property (strong,nonatomic)UITableView *myOrderTableview;//列表

@end

@implementation myOrderViewController

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
    [self setHiddenTabbar:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        [self getDataFromNet];
    }
}

#pragma mark-----init data
-(void)initData
{
    page = 1;
    cate_id = @"0";
    myOrderArray = [[NSMutableArray alloc] init];
}

#pragma mark-----set UI
-(void)setUI
{
    [self setNavBarTitle:@"订单" withFont:14.0f];
    [self setCateButton];
    [self.view addSubview:self.myOrderTableview];
    [_myOrderTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_myOrderTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_myOrderTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_myOrderTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40.0f];
    //添加分割线
    UIImageView *lineImage = [[UIImageView alloc] initForAutoLayout];
    [self.view addSubview:lineImage];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [lineImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [lineImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_myOrderTableview withOffset:0.0f];
    [lineImage autoSetDimension:ALDimensionHeight toSize:0.5f];
    lineImage.layer.borderColor = UIColorFromRGB(0xc3c3c3).CGColor;
    lineImage.layer.borderWidth = 0.5;
}

#pragma mark-----设置分类按钮
-(void)setCateButton
{
    NSArray *titleArray = @[@"全部",@"未送达",@"待评价",@"已取消"];
    NSArray *tagArray = @[@"0",@"1",@"2",@"3"];
    
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

-(void)getDataFromNet
{
    NSString *url = connect_url(@"my_takeout");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"page":[NSString stringWithFormat:@"%d",page],
                           @"u_id":[UserModel shareInstance].u_id,
                           @"where":cate_id
                           };
    [Base64Tool  postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            if (page == 1) {
                [myOrderArray removeAllObjects];
            }
            NSArray *arr = param[@"obj"];
            for (NSDictionary *dic in arr) {
                myOrderCenterInfo *info = [[myOrderCenterInfo alloc] initWithDictionary:dic];
                [myOrderArray addObject:info];
            }
            [self.myOrderTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        [self.myOrderTableview headerEndRefreshing];
        [self.myOrderTableview footerEndRefreshing];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark------get UI
-(UITableView *)myOrderTableview
{
    if (!_myOrderTableview) {
        _myOrderTableview = [[UITableView alloc] initForAutoLayout];
        _myOrderTableview.delegate = self;
        _myOrderTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_myOrderTableview];
        _myOrderTableview.separatorInset = UIEdgeInsetsZero;
        [_myOrderTableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
        [_myOrderTableview addFooterWithTarget:self action:@selector(footerBeginRefreshing)];
        _myOrderTableview.footerPullToRefreshText = @"上拉可以加载更多数据了";
        _myOrderTableview.footerReleaseToRefreshText = @"松开马上加载更多数据了";
        _myOrderTableview.footerRefreshingText = @"正在刷新";
        _myOrderTableview.headerPullToRefreshText = @"下拉可以刷新了";
        _myOrderTableview.headerReleaseToRefreshText = @"松开马上刷新了";
        _myOrderTableview.headerRefreshingText = @"马上回来";
        if ([_myOrderTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myOrderTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_myOrderTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myOrderTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _myOrderTableview;
}

#pragma mark------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"进入订单详情");
    myOrderCenterInfo *info = [myOrderArray objectAtIndex:indexPath.row];
//    if ([info.is_pay integerValue]!=0) {
        OrderDetailViewController *firVC = [[OrderDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"订单详情" withFont:14.0f];
        firVC.order_id = info.order_id;
        firVC.identifier = @"1";
        firVC.takeout_url = info.takeout_url;
        [self.navigationController pushViewController:firVC animated:YES];
//    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"my_order_center_cell";
    myOrderCenterTableViewCell *cell=(myOrderCenterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[myOrderCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    myOrderCenterInfo *info = [myOrderArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell confirgureCell:info row:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myOrderArray count];
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

-(void)reviewDelegateAction:(NSInteger)index
{
    myOrderCenterInfo *info = [myOrderArray objectAtIndex:index];
    RviewDishListViewController *firVC = [[RviewDishListViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"评价" withFont:14.0f];
    firVC.order_id = info.order_id;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)customPayActionDelegate:(NSInteger)index
{
    NSLog(@"去支付");
    myOrderCenterInfo *info = [myOrderArray objectAtIndex:index];
    [self jumpAlpay:info.order_id totalPrice:info.total_price];
}

/**
 跳转支付宝
 */
-(void)jumpAlpay :(NSString*)orderId totalPrice:(NSString*)myPrice
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088712472346745";
    NSString *seller = @"hongdingnet@163.com";
    NSString *privateKey = @"MIIEpAIBAAKCAQEA6mXWmjfqmSn6pN4x2QAmPvM+jmYWKAPaTQI++xGDHTF79Tna/NFKjwZitH5uyVEoHc1XlVYqW8bj7nMKUoW+y4s15fuhGny4gN162Ws5Be+pH1B3z+2hTkdv5Fn7VrkdpV9DCsTde8IhU+2JMLkZ/2t38vNS4rZMOY1CO8g+QepvynOmnR/LRBip5kruFv9c656PNBr6G7wlJ8mk+etBUwrZW6geif6d8jJzLSihTmMXCljzNHmjflt90TR8T8ifY7S1cyyQkj6YXKR1v5sjpn2FvPKJAkYY6lL5Lfy6lrxPa+Sd9Bv5waQis1ak2hHu0d7uIQInc75oU7tmIqFmOQIDAQABAoIBAQCv9c9KaluUq2zbQ2oMSw5rB1OYto4/b9T7Jop9E8JnsfQqPUplq//aqqKCeL9WJbSF2ta65rpZt074fCftlzWJu3G0uldQePxQ0PMeMF3YVPeS6GdpEiybhQk8VUhW7BSTRpYfiXXzJ+K5DIKGrw4TLmwXWA6K3usN8Tsdgc8qzxFC3vFIFnYJHgVZ3wVB8E/zJCaPgunjt35PWZUwyKLlhpR2PDZ2E7mXkjdXOM8FneMOo6Qgbyzh3j/7Ag8SRMuofb7DYvlGIkLW40TpE2vE1bgl/7CuSTI228zXfgRWp43VrpLyZPMLZxBbKCxB1EKFFEzrPWmouWKLkXA9Z075AoGBAPsdHtIbyZv8QuAyKmjMa9vmmE9WQ5Md1E9X9Vhop9fh8xKjujtgRnhhQgt2TDVuJ5iQ3/MSJjA3yOadFe/uBFRWvAx2z3dJEF/1QK0ZS12THRECCyMzKqX5lkJjErvKJ7aT2hVdaWI0cKgbZG6ggvajCE6mkixto5N54hQ3G+k7AoGBAO71c0esXuJdfdt6rcnw2ZMMGcDstIrPJobBpSx4durciWYt+LT5u2U6oAHCtA05AliZ2FBHBkFZJKG/6lYeVKCRbw2daYgX0qpf4sUpWppa2AQbmHJ8GiqUqsDUHqUT2P/NucsYI7fc/Y0rM49ZiUkUVot/1j6oYo9OkrXCepcbAoGAP4o7zUB4wD6RkXdAIepv9GGh8plKWgR3P2hrTWaV6dtjjTjem72dt0Is2weg+vgXjtRBxpi2Dwdej3P6JA7fC5Qy2xiJII7dVNqS9fnrhw79kNsqhEqjJQJFkiDNkbTyXZGF4lgTnWTViMP9orx8xvmz1Wrym8lWVa/GlATpzBcCgYAY8nMYlnxJca1EDqi6HnT4jxjZNV0b6MiC5RCTdfgkSOXnTwFaE4Bm7xnpVSRrBPqjuVwF9YRHqkDSyjBy0TPQl55ac4ai+Km7s8r+/nRBDR7kPuVJfn9U1rSE8SBJ56qN+jJda6W++klWRZ5aZuSYRpFKewwo+ndfsrpKU4Vs5QKBgQCBPtBK4CcihHa5JGldewVQrISTvnTnB83iS9o4ljFAK/fBrX//76Dm2qY57kxSM2oeFcrCUc/6immF4k1SS2DlcaiCh7gm1gZdXlpCPqN+qKgSkvhwpsuJHUlxIxZa8fEusBRBHwXHvziIX8wgV2LmC/GMFj8bgPZGvgv0STs4Ig==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderId; //订单ID（由商家自行制定）
    order.productName = @"外卖订单"; //商品标题
    order.productDescription = @"专业送餐20年"; //商品描述
    float myTotal = [myPrice floatValue];
    order.amount = [NSString stringWithFormat:@"%0.2f",myTotal]; //商品价格
    order.notifyURL =  @"http://manager.114lives.com/alipay/phoneAlipay/notify_url"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            BOOL is_success = NO;
            NSString *resultSting = resultDic[@"result"] ;
            NSArray *resultStringArray =[resultSting componentsSeparatedByString:NSLocalizedString(@"&", nil)];
            for (NSString *str in resultStringArray)
            {
                NSString *newstring = nil;
                newstring = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSArray *strArray = [newstring componentsSeparatedByString:NSLocalizedString(@"=", nil)];
                for (int i = 0 ; i < [strArray count] ; i++)
                {
                    NSString *st = [strArray objectAtIndex:i];
                    if ([st isEqualToString:@"success"])
                    {
                        is_success = YES;
                        NSLog(@"%@",[strArray objectAtIndex:1]);
                        break;
                    }
                }
                //跳出循环判断
                if (is_success) {
                    break;
                }
            }
            //判断支付成功 去跳转到支付成功页面  ---访问后台接口为准
            if ([resultDic[@"resultStatus"] integerValue] == 9000 && is_success) {
                [self.myOrderTableview headerBeginRefreshing];
            }else{
#pragma mark --- 12.10 去掉未支付订单自动删除的提示 by CC
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"o2o助手" message:@"未支付订单将会在30分钟后自动删除" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                [alert show];
            }
        }];
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
