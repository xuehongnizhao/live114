//
//  AppUpdatesController.m
//  ZhongWeiAliance
//
//  Created by mac on 15/11/18.
//  Copyright © 2015年 mac. All rights reserved.
//
//  中位 -----> APP更新页面

#import "AppUpdatesController.h"

@interface AppUpdatesController ()


#pragma mark - UI   Propertys
/*! ---------------------- UI  控件 ---------------------- !*/
@property (nonatomic, strong) UIWebView * AppUpdatesWebView;  //APP更新webView
#pragma mark - Data Propertys
/*! ---------------------- 数据模型 ---------------------- !*/

@end

@implementation AppUpdatesController

#pragma mark - Lifecycle Methods
/*!
 *  视图控制器 载入完成 调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
}

/*!
 *  视图控制器 即将加入窗口 调用
 *
 *  @param animated
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

/*!
 *  视图控制器 已经显示窗口时 调用
 *
 *  @param animated
 */
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


/*!
 *  内存不足时 调用
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*!
 *  当前 控制器 被销毁时 调用
 */
- (void) dealloc {
    NSLog(@" selfViewController Destroy ");
}

#pragma mark - Init Data Method
/*!
 *  数据初始化
 */
- (void) initData {
    NSLog(@"更新网址:%@",self.webURL);
    NSURL *url            = [NSURL URLWithString:self.webURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.AppUpdatesWebView loadRequest:request];
}

#pragma mark - Setting UI Methods
/*!
 *  初始化UI控件
 */
- (void) initUI {
    
    [self settingNav];
    [self addUI];
    [self settingUIAutoLayout];
    
}

/*!
 *  设置导航控制器
 */
- (void) settingNav {
//    [self settingNavigationBarTitle:@"更新APP" textColor:nil titleFontSize:NAVIGATION_TITLE_FONT_SIZE];
    //隐藏去首页的"返回按钮"
//    [self.navigationItem setHidesBackButton:YES];
    self.rdv_tabBarController.tabBarHidden = YES;
}

/*!
 *  添加控件
 */
- (void) addUI {
    [self.view addSubview:self.AppUpdatesWebView];
}

/*!
 *  设置控件的自动布局
 */
- (void) settingUIAutoLayout {
    [self.AppUpdatesWebView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.AppUpdatesWebView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.AppUpdatesWebView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.AppUpdatesWebView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

- (UIWebView *) AppUpdatesWebView
{
    if (!_AppUpdatesWebView) {
        _AppUpdatesWebView = [[UIWebView alloc] initForAutoLayout];
    }
    return _AppUpdatesWebView;
}


@end
