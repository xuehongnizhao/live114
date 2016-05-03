//
//  SubmitOrderViewController.m
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖 - 提交订单（付款）

#import "SubmitOrderViewController.h"
#import "userAddressInfo.h"
#import "AddressMangeViewController.h"
#import "XHRealTimeBlur.h"
#import "RemarkViewController.h"
#import "sumitSuccessViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

@interface SubmitOrderViewController ()<UITableViewDataSource,UITableViewDelegate,selectAddressDelegate,finishDelegate>
{
    BOOL is_reach;
    BOOL is_first;
    NSMutableArray *addressArray;
    //----set order message------AddressMangeViewController
    NSString *address;
    NSString *phone;
    NSString *sendTime;
    NSString *hintText;
    NSString *takeout_url;
}
@property (strong, nonatomic) UITableView *LinSubmitTableview;
@property (strong, nonatomic) UIButton *submitButton;

//时间选择器
@property (strong, nonatomic) UIDatePicker       *datePicker;
@property (strong, nonatomic) UIView             *pickerToolbar;

//支付方式选择button
@property (strong, nonatomic) UIButton          *cashButton;
@property (strong, nonatomic) UIButton          *webButton;
@end

@implementation SubmitOrderViewController

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
    [self getDataFromNet];
}

#pragma mark--------get Address
-(void)getDataFromNet
{
    NSString *url = connect_url(@"takeout_address");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [SVProgressHUD showWithStatus:@"请稍候" maskType:SVProgressHUDMaskTypeBlack];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [addressArray removeAllObjects];
            [SVProgressHUD dismiss];
            NSArray *tmpArray = [param objectForKey:@"obj"];
            for (NSDictionary *dic in tmpArray) {
                userAddressInfo *info = [[userAddressInfo alloc] initWithNSDictionary:dic];
                [addressArray addObject:info];
                if ([info.is_default isEqualToString:@"1"]) {
                    address = info.as_address;
                    phone = info.as_tel;
                    is_reach = YES;
                    //break;
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
        [self.LinSubmitTableview reloadData];
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark--------init data
-(void)initData
{
    is_reach = NO;
    is_first = YES;
    addressArray = [[NSMutableArray alloc]init];
    
    address = @"点击设置送餐地址和电话";
    sendTime = @"尽快送出";
    hintText = @"输入备注信息";
    
}

#pragma mark--------set UI
-(void)setUI
{
    [self.view addSubview:self.LinSubmitTableview];
    [_LinSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_LinSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_LinSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_LinSubmitTableview autoSetDimension:ALDimensionHeight toSize:360.0f];
    
    [self.view addSubview:self.submitButton];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [_submitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [_submitButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_submitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_LinSubmitTableview withOffset:15.0f];
}

#pragma mark--------get UI
-(UIButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] initForAutoLayout];
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 4.0f;
        [_submitButton setTitle:@"确认订单" forState:UIControlStateNormal];
        [_submitButton setTitle:@"确认订单" forState:UIControlStateHighlighted];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_submitButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

//webbutton  支付宝支付方式
-(UIButton *)webButton
{
    if (!_webButton) {
        _webButton = [[UIButton alloc] initForAutoLayout];
        _webButton.tag = 101;
        //        _webButton.layer.borderWidth = 1;
        [_webButton setImage:[UIImage imageNamed:@"paymenyt_sel"] forState:UIControlStateSelected];
        [_webButton setImage:[UIImage imageNamed:@"paymenyt_no"] forState:UIControlStateNormal];
        _webButton.selected = YES;
        [_webButton addTarget:self action:@selector(selectMyWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _webButton;
}
//cashButton 现金支付
-(UIButton *)cashButton
{
    if (!_cashButton) {
        _cashButton = [[UIButton alloc] initForAutoLayout];
        _cashButton.tag = 102;
        //        _cashButton.layer.borderWidth = 1;
        [_cashButton setImage:[UIImage imageNamed:@"paymenyt_sel"] forState:UIControlStateSelected];
        [_cashButton setImage:[UIImage imageNamed:@"paymenyt_no"] forState:UIControlStateNormal];
        _cashButton.selected = NO;
        [_cashButton addTarget:self action:@selector(selectMyWay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashButton;
}

-(UITableView *)LinSubmitTableview
{
    if (!_LinSubmitTableview) {
        _LinSubmitTableview = [[UITableView alloc] initForAutoLayout];
        _LinSubmitTableview.separatorInset = UIEdgeInsetsZero;
        //        _LinSubmitTableview.layer.borderWidth = 1;
        //        _LinSubmitTableview.layer.borderColor = [UIColor blackColor].CGColor;
        _LinSubmitTableview.delegate = self;
        _LinSubmitTableview.dataSource = self;
        _LinSubmitTableview.scrollEnabled = NO;
        if ([_LinSubmitTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_LinSubmitTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_LinSubmitTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_LinSubmitTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _LinSubmitTableview;
}

#pragma mark-----table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    return 5.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击无效的事件");
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        AddressMangeViewController *firVC = [[AddressMangeViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"收货地址管理" withFont:14.0f];
        //        [firVC.navigationItem setTitle:@"收货地址管理"];
        firVC.delegate = self;
        firVC.addressArray = addressArray;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if (section == 1){
        if (row==0) {
            NSLog(@"弹出时间选择器");
            [self chooseTime];
        }else if (row == 1){
            
        }else if (row == 2){
            NSLog(@"跳转备注---");
            [self go2Remark];
        }
    }else if (section == 2){
        if (row == 0) {
            
        }else if (row == 1){
            
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    CGFloat height;
    switch (section) {
        case 0:
            height = 70.0;
            break;
        case 1:
            height = 45.0;
            break;
        case 2:
            height = 45.0;
            break;
            
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_order_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //标题
    UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
    [cell.contentView addSubview:titleLable];
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.font = [UIFont systemFontOfSize:14.0f];
    titleLable.textColor = UIColorFromRGB(0x484848);
    //titleLable.layer.borderWidth = 1;
    [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    //[titleLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
    
    UILabel *textLable = [[UILabel alloc] initForAutoLayout];
    [cell.contentView addSubview:textLable];
    //textLable.layer.borderWidth = 1;
    [textLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [textLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [textLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    
    textLable.textAlignment = NSTextAlignmentRight;
    textLable.font = [UIFont systemFontOfSize:14.0f];
    textLable.textColor = UIColorFromRGB(singleTitle);
    //-----设置显示-------
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        titleLable.text = address;
        [textLable setHidden:YES];
        [titleLable autoSetDimension:ALDimensionWidth toSize:250.0f];
        [textLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLable withOffset:5.0f];
        //phone num----
        UILabel *phoneNum = [[UILabel alloc] initForAutoLayout];
        //phoneNum.layer.borderWidth = 1;
        phoneNum.text = phone;
        [cell.contentView addSubview:phoneNum];
        phoneNum.textColor = UIColorFromRGB(singleTitle);
        phoneNum.font = [UIFont systemFontOfSize:14.0f];
        [phoneNum autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:12.0f];
        [phoneNum autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLable withOffset:3.0f];
        [phoneNum autoAlignAxis:ALAxisVertical toSameAxisOfView:titleLable];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }else if (section == 1){
        [titleLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        [textLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLable withOffset:5.0f];
        if (row==0) {
            titleLable.text = @"送餐时间";
            textLable.text = sendTime;
        }else if (row == 1){
            titleLable.text = @"发票信息";
            textLable.text = @"餐厅暂不支持发票";
        }else if (row == 2){
            titleLable.text = @"备注";
            textLable.text = hintText;
        }
    }else if (section == 2){
        [titleLable autoSetDimension:ALDimensionWidth toSize:100.0f];
        if (row == 0) {
            [textLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLable withOffset:5.0f];
            titleLable.text = @"选择支付方式";
            [textLable setHidden:YES];
            //添加总价
            UILabel *total_lable = [[UILabel alloc] initForAutoLayout];
            //            total_lable.layer.borderWidth = 1;
            total_lable.font = [UIFont systemFontOfSize:14.0f];
            total_lable.textColor = UIColorFromRGB(singleTitle);
            total_lable.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:total_lable];
            [total_lable autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLable];
            [total_lable autoSetDimension:ALDimensionHeight toSize:15.0f];
            [total_lable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            float total_lin = [self.totalPrice floatValue];
            total_lable.text = [NSString stringWithFormat:@"总价:%0.2f",total_lin];
            
        }else if (row == 1){
            titleLable.text = @"餐到付款";
            [textLable autoSetDimension:ALDimensionWidth toSize:25.0f];
            [cell.contentView addSubview:self.cashButton];
            [_cashButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_cashButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_cashButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_cashButton autoSetDimension:ALDimensionWidth toSize:30.0f];
            
        }else if (row == 2){
            titleLable.text = @"支付宝支付";
            [textLable autoSetDimension:ALDimensionWidth toSize:25.0f];
            [cell.contentView addSubview:self.webButton];
            [_webButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
            [_webButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
            [_webButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
            [_webButton autoSetDimension:ALDimensionWidth toSize:30.0f];
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            if (is_first) {
                count = 1;
            }else{
                count = 1;
            }
            break;
        case 1:
            count = 3;
            break;
        case 2:
            count = 3;
            break;
            
        default:
            break;
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

#pragma mark--------submit action
-(void)submitAction:(UIButton*)sender
{
    if (_webButton.selected == YES) {
        NSLog(@"支付宝支付");
        [self payWebAlpay];
    }else{
        NSLog(@"餐到付款");
        [self payCash];
    }
}

/**
 餐到付款
 */
-(void)payCash
{
    NSLog(@"提示：确认提交吗？");
    if (address == nil || [address isEqualToString:@""] || phone == nil || [phone isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择送餐地址和电话"];
        return;
    }
    NSString *url = connect_url(@"add_order");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"session_key":[UserModel shareInstance].session_key,
                           @"send_address":address,
                           @"order_tel":phone,
                           @"shop_id":self.shop_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"pay_time":sendTime,
                           @"note":hintText,
                           @"order_desc":self.orderJson,
                           @"total_price":self.totalPrice,
                           @"cash":@"1"
                           };
    [SVProgressHUD showWithStatus:@"正在提交订单" maskType:SVProgressHUDMaskTypeBlack];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSString *order_id = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"order_id"]];
            takeout_url = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"takeout_url"]];
            sumitSuccessViewController *firVC = [[sumitSuccessViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"订单提交成功" withFont:14.0f];
            firVC.order_id = order_id;
            firVC.takeout_url = takeout_url;
            [self.navigationController pushViewController:firVC animated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

/**
 在线支付
 */
-(void)payWebAlpay
{
    NSLog(@"提示：确认提交吗？");
    NSString *url = connect_url(@"add_order");
    if (address == nil || [address isEqualToString:@""] || phone == nil || [phone isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请选择送餐地址和电话"];
        return;
    }
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"session_key":[UserModel shareInstance].session_key,
                           @"send_address":address,
                           @"order_tel":phone,
                           @"shop_id":self.shop_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"pay_time":sendTime,
                           @"note":hintText,
                           @"order_desc":self.orderJson,
                           @"total_price":self.totalPrice,
                           @"cash":@"0"
                           };
    [SVProgressHUD showWithStatus:@"正在下订单" maskType:SVProgressHUDMaskTypeBlack];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSString *order_id = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"order_id"]];
            //在这该跳转支付宝了
            takeout_url = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"takeout_url"]];
            [self jumpAlpay:order_id];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

/**
 跳转支付宝
 */
-(void)jumpAlpay :(NSString*)orderId
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
    order.productDescription = @"专业送餐"; //商品描述
    float myTotal = [self.totalPrice floatValue];
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
                sumitSuccessViewController *firVC = [[sumitSuccessViewController alloc] init];
                [firVC setHiddenTabbar:YES];
                [firVC setNavBarTitle:@"订单提交成功" withFont:14.0f];
                firVC.order_id = orderId;
                firVC.takeout_url = takeout_url;
                [self.navigationController pushViewController:firVC animated:YES];
            }
        }];
    }
    
}

#pragma mark--------select address delegate
-(void)selectAddress:(NSString *)address_str phone:(NSString *)phone_str
{
    address = address_str;
    phone = phone_str;
    [self.LinSubmitTableview reloadData];
}

#pragma mark--------pick time
-(void)chooseTime
{
    //显示时间选择器
    // 显示时间选择器
    if (!_datePicker && !_pickerToolbar) {
        [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleBlackTranslucent];
        _datePicker = [[UIDatePicker alloc] initForAutoLayout];
        [self.view addSubview:_datePicker];
        //---auto layout------
        [_datePicker autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30.0f];
        [_datePicker autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:100.0f];
        [_datePicker autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30.0f];
        [_datePicker autoSetDimension:ALDimensionHeight toSize:150.0f];
        
        NSDate *today =[[NSDate alloc]init];
        _datePicker.minimumDate = today;
        _datePicker.backgroundColor = [UIColor whiteColor];
        //datePicker.datePickerMode = UIDatePickerModeDate;
        // UIDatePickerModeCountDownTimer
        _datePicker.datePickerMode=UIDatePickerModeTime;
        //UIDatePickerModeCountDownTimer 24小时制
        _datePicker.minuteInterval = 10;
        //[datePicker setMinimumDate:[NSDate date]];
        
        _pickerToolbar = [[UIView alloc] initForAutoLayout];
        [self.view addSubview:_pickerToolbar];
        [_pickerToolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30.0f];
        [_pickerToolbar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30.0f];
        [_pickerToolbar autoSetDimension:ALDimensionHeight toSize:36.0f];
        [_pickerToolbar autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_datePicker withOffset:0.0f];
        
        _pickerToolbar.backgroundColor = Color(67, 67, 67, 0.8);
        
        UIToolbar *keyToolbar = [[UIToolbar alloc] initForAutoLayout];
        [_pickerToolbar addSubview:keyToolbar];
        [keyToolbar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [keyToolbar autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [keyToolbar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [keyToolbar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        
        keyToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *doneButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(myDismissDatePicker)];
        UIBarButtonItem *spaceBarItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                      target:nil
                                                      action:nil];
        if (IOS7) {
            doneButtonItem.tintColor = [UIColor whiteColor];
        }
        [keyToolbar setItems:@[spaceBarItem,doneButtonItem]];
        self.pickerToolbar = _pickerToolbar;
        [self.view addSubview:_pickerToolbar];
    }
}

//记录时间
- (void)myDismissDatePicker
{
    // 记录时间
    NSDate *time = [self.datePicker date];
    //NSLog(@"");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:time];
    NSLog(@"选择的时间是%@",timeStr);
    sendTime = timeStr;
    [self.LinSubmitTableview reloadData];
    if (self.datePicker) {
        [self.datePicker removeFromSuperview];
        self.datePicker = nil;
    }
    if (self.pickerToolbar) {
        [self.pickerToolbar removeFromSuperview];
        self.pickerToolbar = nil;
    }
    [self.view disMissRealTimeBlur];
}

-(void)go2Remark
{
    RemarkViewController *firVC = [[RemarkViewController alloc] init];
    [firVC setNavBarTitle:@"备注信息" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"备注信息"];
    [firVC setHiddenTabbar:YES];
    if (hintText == nil || [hintText isEqualToString:@""] == YES ||[hintText isEqualToString:@"输入备注信息"] == YES) {
        
    }else {
        firVC.noteString = hintText;
    }
    firVC.delegate = self;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)finishActionDelegate:(NSString *)remarkStr
{
    if (remarkStr == nil || [remarkStr isEqualToString:@""] == YES) {
        hintText = @"输入备注信息";
    }else{
        hintText = remarkStr;
    }
    [self.LinSubmitTableview reloadData];
}

//选择支付方式
-(void)selectMyWay:(UIButton*)sender
{
    NSLog(@"选择支付方式");
    if (sender.tag == 102) {
        _webButton.selected = NO;
        _cashButton.selected = YES;
    }else{
        _webButton.selected = YES;
        _cashButton.selected = NO;
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
