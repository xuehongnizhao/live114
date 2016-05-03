//
//  orderSeatSuccessViewController.m
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "orderSeatSuccessViewController.h"
#import "XHRealTimeBlur.h"
#import "checkStatusView.h"
#import "orderSeatDetailViewController.h"
#import "mySeatSuccessViewController.h"


@interface orderSeatSuccessViewController ()<checkStatusDelegate>
@property (strong,nonatomic)UIWebView *submitSuccessWeb;
@property (strong,nonatomic)UIButton *checkButton;
@property (strong,nonatomic)UIButton *backButton;
@end

@implementation orderSeatSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------set UI
-(void)setUI
{
#pragma mark --- 2015.12.21 查看订单进度按钮，去掉。（预定酒店和订座位）
    //    [self.view addSubview:self.checkButton];
    //    [_checkButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    //    [_checkButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    //    [_checkButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    //    [_checkButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [self.view addSubview:self.submitSuccessWeb];
    [_submitSuccessWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_submitSuccessWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_submitSuccessWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    //    [_submitSuccessWeb autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_checkButton withOffset:-10.0f];
    [_submitSuccessWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-10.0f];
    [_submitSuccessWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.leftBarButtonItem = leftBar;
}

#pragma mark-------get UI
-(UIWebView *)submitSuccessWeb
{
    if (!_submitSuccessWeb) {
        _submitSuccessWeb = [[UIWebView alloc] initForAutoLayout];
    }
    return _submitSuccessWeb;
}

-(UIButton *)checkButton
{
    if (!_checkButton) {
        _checkButton = [[UIButton alloc] initForAutoLayout];
        [_checkButton setTitle:@"查看进度" forState:UIControlStateNormal];
        [_checkButton setTitle:@"查看进度" forState:UIControlStateHighlighted];
        [_checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_checkButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_checkButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_checkButton addTarget:self action:@selector(checkAtion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkButton;
}

-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(-20, -20, 0, 20);
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(void)backAction:(UIButton*)sender
{
    NSLog(@"自定义返回-----暂定返回主界面--需要修改");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)checkAtion:(UIButton*)sender
{
    NSLog(@"查看进度");
    [self.view showRealTimeBlurWithBlurStyle:XHBlurStyleBlackTranslucent];
    checkStatusView *picker = [[checkStatusView alloc] initForAutoLayout];
    picker.delegate = self;
    [self.view addSubview:picker];
    [picker autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
    [picker autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50.0f];
    [picker autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
    [picker autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20.0f];
    [picker setSeatId:self.seat_id];
}

-(void)cancelAction
{
    [self.view disMissRealTimeBlur];
}

-(void)deleteOrderSeat
{
    [self.view disMissRealTimeBlur];
    NSString *url = connect_url(@"seat_cancel");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"seat_id":self.seat_id,
                           @"u_id":[UserModel shareInstance].u_id,
                           @"session_key":[UserModel shareInstance].session_key
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            NSLog(@"取消成功");
            NSLog(@"返回到商家详情");
            NSArray *subViews = self.navigationController.viewControllers;
            for (BaseViewController *obj in subViews) {
                if ([obj isKindOfClass:[orderSeatDetailViewController class]]) {
                    [self.navigationController popToViewController:obj animated:YES];
                    break;
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)orderSuccessAction
{
    NSLog(@"跳转页面");
    mySeatSuccessViewController *firVC = [[mySeatSuccessViewController alloc] init];
    [firVC.navigationItem setHidesBackButton:YES];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"预定成功" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"预定成功"];
    firVC.seat_id = self.seat_id;
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
