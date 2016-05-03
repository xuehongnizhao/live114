//
//  ShopDetailWebViewController.m
//  cityo2o
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 Sky. All rights reserved.
//
//  如e生活 -----> 商家详情（web）

#import "ShopDetailWebViewController.h"

@interface ShopDetailWebViewController ()<UIWebViewDelegate>
/** 商家详情 */
@property (nonatomic ,strong) UIWebView * shopDetailWebView;
@end

@implementation ShopDetailWebViewController

#pragma mark 生命周期方法

/**
 *  页面加载之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

/**
 *  内存不足时候调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  页面将要消失时候调用
 *
 *  @param animated
 */
- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 移除 webView
    [self.shopDetailWebView removeFromSuperview];
}


#pragma mark ----- 初始化UI控件

/**
 *  初始化UI控件
 */
- (void) initUI {
    [self.view addSubview:self.shopDetailWebView];
    [self.shopDetailWebView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.shopDetailWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.shopDetailWebView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.shopDetailWebView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
}

/**
 *  set方法设置webView的URL
 *
 *  @param shopDetailWebURL shopDetailWebURL
 */
-(void) setShopDetailWebURL:(NSString *)shopDetailWebURL
{
    _shopDetailWebURL = shopDetailWebURL;
    [self.shopDetailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shopDetailWebURL]]];
}

#pragma mark - WebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完毕");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"商家详情web页加载失败：%@",error);
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}

#pragma mark - 懒加载 
- (UIWebView *) shopDetailWebView
{
    if (!_shopDetailWebView) {
        _shopDetailWebView = [[UIWebView alloc] initForAutoLayout];
        _shopDetailWebView.delegate = self;
        _shopDetailWebView.backgroundColor = [UIColor whiteColor];
    }
    return _shopDetailWebView;
}

@end
