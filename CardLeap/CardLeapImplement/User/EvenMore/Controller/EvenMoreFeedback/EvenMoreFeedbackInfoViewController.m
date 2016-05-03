//
//  EvenMoreFeedbackInfoViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreFeedbackInfoViewController.h"

@interface EvenMoreFeedbackInfoViewController () <UIWebViewDelegate>

// ---------------------- UI 控件 ----------------------
/** 显示详情的WebView */
@property (weak, nonatomic) UIWebView *infoWebView;

@end

@implementation EvenMoreFeedbackInfoViewController

#pragma mark  ----- 生命周期方法

/**
 *  页面加载之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    
    [self jumpInfo];
}


/**
 *  页面即将消失调用
 *
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    // 移除 webView
    [self.infoWebView removeFromSuperview];
}

/**
 *  内存不足时调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----- 初始化UI控件

/**
 *  初始化控件
 */
- (void) initUI {
    [self settingNav];
    
    [self infoWebView];
}

/**
 *  设置 导航栏
 */
- (void) settingNav {
    self.navigationItem.title = @"详情";
}


/**
 *  添加 webView
 *
 *  @return UIWebView
 */
- (UIWebView *)infoWebView {
    
    if (_infoWebView == nil) {
        
        UIWebView *infoWebView = [[UIWebView alloc] init];
        CGFloat infoX = self.view.frame.origin.x;
        CGFloat infoY = self.view.frame.origin.y;
        CGFloat infoW = self.view.frame.size.width;
        CGFloat infoH = self.view.frame.size.height - 64;
        infoWebView.frame = CGRectMake(infoX, infoY, infoW, infoH);
        infoWebView.delegate        = self;
        infoWebView.backgroundColor = [UIColor whiteColor];
        _infoWebView                = infoWebView;
        [self.view addSubview:_infoWebView];
    }
    return _infoWebView;
}

/**
 *  跳转详情
 */
- (void) jumpInfo {
    
    NSURL *url            = [NSURL URLWithString:self.message_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载url
    [self.infoWebView loadRequest:request];
}

#pragma mark ----- UIWebView delegate

/**
 *  webView 加载完毕之后调用的方法
 *
 *  @param webView
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    // 禁止选中效果
    [self.infoWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

@end
