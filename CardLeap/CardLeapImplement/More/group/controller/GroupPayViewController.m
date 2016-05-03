//
//  GroupPayViewController.m
//  CardLeap
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "GroupPayViewController.h"
#import "groupPayTableViewCell.h"
#import "payAlipayWebViewController.h"
#import "GroupPaySuccessViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

@interface GroupPayViewController ()<UITableViewDataSource,UITableViewDelegate,choosePayMethodeDelegate,completeDelegate>
{
    NSInteger chooseIndex;
    NSString *order_id;
}
@property (strong,nonatomic)UITableView *groupPayTableview;
@property (strong,nonatomic)UIButton *payButton;
@end

@implementation GroupPayViewController

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

#pragma mark-----init data
-(void)initData
{
    chooseIndex = 0;
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view addSubview:self.groupPayTableview];
    [_groupPayTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_groupPayTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_groupPayTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_groupPayTableview autoSetDimension:ALDimensionHeight toSize:240.0f];
    
    [self.view addSubview:self.payButton];
    [_payButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_payButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_payButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_payButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_groupPayTableview withOffset:5.0f];
}

#pragma mark-----get UI
-(UITableView *)groupPayTableview
{
    if (!_groupPayTableview) {
        _groupPayTableview = [[UITableView alloc] initForAutoLayout];
        _groupPayTableview.delegate = self;
        _groupPayTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_groupPayTableview];
        _groupPayTableview.separatorInset = UIEdgeInsetsZero;
        [_groupPayTableview setScrollEnabled:NO];
        if ([_groupPayTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_groupPayTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_groupPayTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_groupPayTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _groupPayTableview;
}

-(UIButton *)payButton
{
    if (!_payButton) {
        _payButton = [[UIButton alloc] initForAutoLayout];
        _payButton.layer.masksToBounds = YES;
        _payButton.layer.cornerRadius = 4.0f;
        [_payButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [_payButton setTitle:@"确认支付" forState:UIControlStateHighlighted];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_payButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_payButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40.0;
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_pay_cell";
    groupPayTableViewCell *cell=(groupPayTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupPayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    [cell confirgureCell:indexPath.row param:self.dict index:chooseIndex
     ];
    cell.delegate = self;
//    NSDictionary *dic = @{
//                          @"count":[NSString stringWithFormat:@"%d",count],
//                          @"singel_price":self.submitInfo.now_price,
//                          @"group_name":self.submitInfo.group_name
//                          };
//    [cell configureCell:dic row:indexPath.row];
//    cell.delegate = self;
    //[cell setAc -- cessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark-----pay action
-(void)payAction:(UIButton*)sender
{
    //跳转支付宝
    if (chooseIndex == 0) {
        NSString *url = connect_url(@"group_grab_insert");
        NSString *totalPrice = [NSString stringWithFormat:@"%f",[self.dict[@"singel_price"] floatValue]*[self.dict[@"count"] integerValue]];
        NSDictionary *myDic = @{
                               @"app_key":url,
                               @"session_key":[UserModel shareInstance].session_key,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"group_id":self.dict[@"group_id"],
                               @"grab_num":self.dict[@"count"],
                               @"grab_price":totalPrice
                               };
        [Base64Tool postSomethingToServe:url andParams:myDic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                NSArray *passArray = [param[@"obj"] objectForKey:@"group_pass"];
                NSString *order_ids = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"order_id"]];
                [self clientAlipay:order_ids passArray:passArray];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

-(void)clientAlipay :(NSString *)order_ids passArray:(NSArray*)array
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
    NSString *totalPrice = [NSString stringWithFormat:@"%0.2f",[self.dict[@"singel_price"] floatValue]*[self.dict[@"count"] integerValue]];
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = order_ids; //订单ID（由商家自行制定）
    order.productName = [self.dict objectForKey:@"group_name"]; //商品标题
    order.productDescription = [self.dict objectForKey:@"group_brief"]; //商品描述
    order.amount = totalPrice; //商品价格
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
                GroupPaySuccessViewController *firVC = [[GroupPaySuccessViewController alloc] init];
                [firVC setHiddenTabbar:YES];
                [firVC setNavBarTitle:@"支付成功" withFont:14.0f];
                firVC.passArray = array;
                firVC.order_id = order_ids;
                firVC.messageDict  = self.dict;
                //firVC.info = self.info;
                [self.navigationController pushViewController:firVC animated:YES];
            }
        }];
    }
}

-(void)choosePayAction:(NSInteger)indexPath
{
    chooseIndex = indexPath;
    [self.groupPayTableview reloadData];
}

/**
 这个是做网页支付点击完成之后的返回验证
 */
#pragma mark------complete actino delegate
-(void)completeAction
{
//    NSLog(@"点击完成，返回验证");
//    //[NSThread sleepForTimeInterval:2.5];
//    [SVProgressHUD showWithStatus:@"正在验证,请稍等" maskType:SVProgressHUDMaskTypeNone];
//    NSString *url = connect_url(@"group_check");
//    NSDictionary *dict = @{
//                           @"app_key":url,
//                           @"order_id":self.order_id
//                           };
//    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
//        if ([param[@"code"] integerValue]==200) {
//            [SVProgressHUD dismiss];
//            if ([[param[@"obj"] objectForKey:@"is_pay"] integerValue]==0) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未支付该订单" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//                [alert show];
//            }else{
//                GroupPaySuccessViewController *firVC = [[GroupPaySuccessViewController alloc] init];
//                [firVC setHiddenTabbar:YES];
//                [firVC setNavBarTitle:@"支付成功" withFont:14.0f];
////                [firVC.navigationItem setTitle:@"支付成功"];
//                firVC.passArray = self.passArray;
//                firVC.order_id = order_id;
//                firVC.messageDict = self.dict;
//                //firVC.info = self.info;
//                [self.navigationController pushViewController:firVC animated:YES];
//            }
//        }else{
//            [SVProgressHUD showErrorWithStatus:param[@"message"]];
//        }
//    } andErrorBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络异常"];
//    }];
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
