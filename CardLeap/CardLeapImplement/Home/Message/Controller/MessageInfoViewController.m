//
//  MessageInfoViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "MessageInfoViewController.h"

@interface MessageInfoViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *messageInfoView;

@end

@implementation MessageInfoViewController


#pragma mark ----- 生命周期方法

/**
 *  页面加载完毕之后 加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self jumpWebView];
}

/**
 *  内存不足时候调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----- 初始化UI
/**
 *  初始化控件
 */
- (void) initUI {
    
    [self settingNav];
    [self messageInfoView];
}

/**
 *  设置导航栏
 */
- (void) settingNav {
    self.navigationItem.title = @"详情";
}


/**
 *  添加一个webView
 *
 *  @return UIWebView
 */
- (UIWebView *) messageInfoView {
    if (_messageInfoView == nil) {
        UIWebView *messageInfoView = [[UIWebView alloc] init];
        CGFloat messX = self.view.frame.origin.x;
        CGFloat messY = self.view.frame.origin.y;
        CGFloat messW = self.view.frame.size.width;
        CGFloat messH = self.view.frame.size.height - 64;
        messageInfoView.frame           = CGRectMake(messX, messY, messW, messH);
        messageInfoView.delegate        = self;
        messageInfoView.backgroundColor = [UIColor whiteColor];
        _messageInfoView = messageInfoView;
        [self.view addSubview:_messageInfoView];
    }
    return _messageInfoView;
}


/**
 *  跳转web
 */
- (void) jumpWebView {
    
//    NSLog(@::)
    NSURL        *url     = [NSURL URLWithString:self.message_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.messageInfoView loadRequest:request];
}



#pragma mark ----- UIWebView delegate

/**
 *  webView 加载完毕之后 调用
 *
 *  @param webView
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    // 禁止选中效果
    [self.messageInfoView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
}

@end
