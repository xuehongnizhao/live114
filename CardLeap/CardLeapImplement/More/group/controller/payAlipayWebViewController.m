//
//  payAlipayWebViewController.m
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "payAlipayWebViewController.h"

@interface payAlipayWebViewController ()<UIWebViewDelegate>
@property (strong,nonatomic)UIWebView *payWebview;
@property (strong,nonatomic)UIButton  *completeButton;
@end

@implementation payAlipayWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------set UI
-(void)setUI
{
    //-----hint message------
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"支付完成后请点击右侧完成按钮" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    //-----ui----
    [self.view addSubview:self.payWebview];
    [_payWebview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_payWebview autoPinEdgeToSuperviewEdge:ALEdgeBottom  withInset:0.0f];
    [_payWebview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_payWebview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.completeButton];
    self.completeButton.userInteractionEnabled = NO;
}

#pragma mark-----get UI
-(UIWebView *)payWebview
{
    if (!_payWebview) {
        _payWebview = [[UIWebView alloc] initForAutoLayout];
        _payWebview.delegate = self;
        [_payWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pay_url]]];
    }
    return _payWebview;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [SVProgressHUD showWithStatus:@"正在加载支付宝订单" maskType:SVProgressHUDMaskTypeNone];
    self.completeButton.userInteractionEnabled = NO;
    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    self.completeButton.userInteractionEnabled = YES;
}

-(UIButton *)completeButton
{
    if (!_completeButton) {
        _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _completeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

#pragma mark-------button action
-(void)completeAction:(UIButton*)sender
{
    NSLog(@"完成支付了");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = NO;
    [self.delegate completeAction];
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
