//
//  EvenMoreToWebViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "EvenMoreToWebViewController.h"

#import "EvenMoreIsToJump.h"

@interface EvenMoreToWebViewController () <UIWebViewDelegate>


// ---------------------- UI 控件 ----------------------
/** UIWebView */
@property (weak, nonatomic) UIWebView *moreWebView;

@end

@implementation EvenMoreToWebViewController


#pragma mark 生命周期方法

/**
 *  页面加载之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
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
    [self.moreWebView removeFromSuperview];
}


#pragma mark ----- 初始化UI控件

/**
 *  初始化UI控件
 */
- (void) initUI {
    [self moreWebView];
}


/**
 *  添加一个webView
 *
 *  @return UIWebView
 */
- (UIWebView *)moreWebView {

    if (_moreWebView == nil) {
        UIWebView *moreWebView = [[UIWebView alloc] init];
        CGFloat moreX = self.view.frame.origin.x;
        CGFloat moreY = self.view.frame.origin.y;
        CGFloat moreW = self.view.frame.size.width;
        CGFloat moreH = self.view.frame.size.height - 64;
        moreWebView.frame           = CGRectMake(moreX, moreY, moreW, moreH);
        moreWebView.backgroundColor = [UIColor whiteColor];
        moreWebView.delegate        = self;
        _moreWebView                = moreWebView;
        [self.view addSubview:_moreWebView];
    }
    return _moreWebView;
}


#pragma mark ----- 初始化数据

/**
 *  数据初始化
 */
- (void) initData {
//    [self getUrl];
    [self webViewJump];
}


/**
 *  获取url
 *
 *  @return     NSString
 */
- (NSURL *) getUrl {
    NSString *string = [NSString string];
    
    if (self.evenMoreJomp.isAboutApp) {
//        NSLog(@"关于我们");
        string = [self joinUrlString:connect_url(@"yz_about")];
    }
    
    if (self.evenMoreJomp.isPrivacy) {
//        NSLog(@"隐私权限");
        string = [self joinUrlString:connect_url(@"privacy")];
    }
    
    if (self.evenMoreJomp.isHelp) {
//        NSLog(@"使用帮助");
        string = [self joinUrlString:connect_url(@"help")];
    }
    
    if (self.evenMoreJomp.isCode) {
//        NSLog(@"二维码");
        string = [self joinUrlString:connect_url(@"code_img")];
    }
    
    NSURL *url = [NSURL URLWithString:string];
    return url;
}



/**
 *  拼接 url 字符串
 *
 *  @param  url
 *
 *  @return NSString
 */
- (NSString *) joinUrlString:(NSString *)url {

    NSString *string = [NSString stringWithFormat:@"http://%@/%@", baseUrl,url];
    return string;
}

/**
 *  跳转 web
 */
- (void) webViewJump {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self getUrl]];
    // 加载url
    [self.moreWebView loadRequest:request];
    
}


#pragma mark ----- UIWebView delegate

/**
 *  webView 加载完毕之后调用的方法
 *
 *  @param webView
 */
- (void) webViewDidFinishLoad:(UIWebView *)webView {
    
    // 禁止选中效果
    [self.moreWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
}





@end
