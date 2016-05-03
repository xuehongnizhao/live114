//
//  CityInfoViewController.m
//  CardLeap
//
//  Created by songweiping on 14/12/28.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityInfoViewController.h"
#import "CityInfoView.h"
#import "MJExtension.h"
#import "CityInfo.h"
#import "RDVTabBarController/RDVTabBarController.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];
#define padding 10

@interface CityInfoViewController () <UIWebViewDelegate>


/** 网络获取出来的数据 */
@property (strong, nonatomic)   CityInfo      *cityInfo;

/** UIScrollView 和轮播器 */
@property (weak, nonatomic)     CityInfoView  *cityInfoView;

/** 中间显示的webView */
@property (weak, nonatomic)     UIWebView     *webView;

/** 工具条的View */
@property (weak, nonatomic)     UIView        *toolView;

/** 显示名称 */
@property (weak, nonatomic)     UILabel       *nameLabel;

/** 显示电话 */
@property (weak, nonatomic)     UILabel       *telLabel;

/** 电话点击拨打 */
@property (weak, nonatomic)     UIButton      *telView;

/** 点击发送信息 */
@property (weak, nonatomic)     UIButton      *messageView;

@end

@implementation CityInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setBackGroudColor];
    self.navigationItem.title = @"详情";
    [self cityInfoView];
    [self webView];
    [self getCityInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBackGroudColor
{
    UIView *view = [[UIView alloc] initForAutoLayout];
    [self.view addSubview:view];
    [view autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [view setBackgroundColor:[UIColor redColor]];
}

#pragma mark @@@@ ----> 页面即将出现时候调用
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
}

#pragma mark @@@@ ----> 页面将要消失时候调用
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    // 移除 从 父类中移除
//    [self.webView removeFromSuperview];
    
    // 显示上一页 tabBar
    //[self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

#pragma mark @@@@ ----> 添加 scrollView 和轮播器
- (CityInfoView *)cityInfoView {
    if (_cityInfoView == nil) {
        CityInfoView *cityInfoView = [[CityInfoView alloc] initWithFrame:self.view.frame];
        [_cityInfoView setBackgroundColor:[UIColor whiteColor]];
        _cityInfoView = cityInfoView;
        [self.view addSubview:_cityInfoView];
    }
    return _cityInfoView;
}

#pragma mark @@@@ ----> 添加webView
- (UIWebView *)webView {
    
    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] init];
        CGFloat webX = self.cityInfoView.scrollView.frame.origin.x;
        CGFloat webY = CGRectGetMaxY(self.cityInfoView.scrollView.frame);
        CGFloat webW = self.cityInfoView.frame.size.width;
        CGFloat webH = 1;
        webView.frame   = CGRectMake(webX, webY, webW, webH);
        [webView setBackgroundColor:[UIColor whiteColor]];
        // webView 关闭滑动
        webView.scrollView.scrollEnabled = NO;
        webView.delegate    = self;
        _webView = webView;
        [self.cityInfoView addSubview:_webView];
    }
    return _webView;
}


#pragma mark @@@@ ----> 添加工具栏
- (UIView *)toolView {
    
    if (_toolView == nil) {
        
        UIView *toolView = [[UIView alloc] init];
        CGFloat toolH  = 60;
        CGFloat toolX  = 0;
        CGFloat toolY  = self.view.frame.size.height - toolH;
        CGFloat toolW  = self.view.frame.size.width;
        toolView.frame = CGRectMake(toolX, toolY, toolW, toolH);
        toolView.backgroundColor = [UIColor whiteColor];
        _toolView = toolView;
        _toolView.layer.borderWidth = 0.5;
        _toolView.layer.borderColor = UIColorFromRGB(0x747474).CGColor;
        [self.view addSubview:_toolView];
    }
    
    return _toolView;
}

#pragma mark @@@@ ----> 名称Label
- (UILabel *)nameLabel {
    
    if (_nameLabel == nil) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        
        CGFloat nameX = padding;
        CGFloat nameY = padding;
        CGFloat nameW = 60;
        CGFloat nameH = 40;
        
        nameLabel.frame = CGRectMake(nameX, nameY, nameW, nameH);
        nameLabel.font = SYSTEM_FONT_SIZE(15);
        nameLabel.textColor = UIColorFromRGB(singleTitle);
        _nameLabel = nameLabel;
        [self.toolView addSubview:_nameLabel];
    }
    return _nameLabel;
}

#pragma mark @@@@ ----> 显示电话 Label
- (UILabel *)telLabel {
    
    if (_telLabel == nil) {
        UILabel *telLabel = [[UILabel alloc] init];
        
        CGFloat telX = CGRectGetMaxX(self.nameLabel.frame) + padding;
        CGFloat telY = self.nameLabel.frame.origin.y;
        CGFloat telW = 100;
        CGFloat telH = self.nameLabel.frame.size.height;
        telLabel.frame     = CGRectMake(telX, telY, telW, telH);
        telLabel.font      = SYSTEM_FONT_SIZE(13);
        telLabel.textColor = UIColorFromRGB(addressTitle);
        _telLabel = telLabel;
        [self.toolView addSubview:_telLabel];
    }
    return _telLabel;
}

#pragma mark @@@@ ---- 短信图片
- (UIButton *)messageView {
    
    if (_messageView == nil) {
        UIButton *messageView = [[UIButton alloc] init];
        
        CGFloat messW = 40;
        CGFloat messH = messW;
        CGFloat messX = self.toolView.frame.size.width - messW - 10;
        CGFloat messY = self.telLabel.frame.origin.y;
        messageView.frame = CGRectMake(messX, messY, messW, messH);
        [messageView setImage:[UIImage imageNamed:@"city_megicon"] forState:UIControlStateNormal];
        messageView.tag = 20;
        [messageView addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        _messageView    = messageView;
        [self.toolView addSubview:_messageView];
    }
    return _messageView;
}

#pragma mark @@@@ ----> 电话图片
- (UIButton *)telView {
    
    if (_telView == nil) {
        
        UIButton *telView = [[UIButton alloc] init];
        
        CGFloat telW  = self.messageView.frame.size.width;
        CGFloat telH  = self.messageView.frame.size.height;
        CGFloat telX  = CGRectGetMidX(self.messageView.frame) - telW * 2;
        CGFloat telY  = self.messageView.frame.origin.y;
        telView.frame = CGRectMake(telX, telY, telW, telH);
        [telView setImage:[UIImage imageNamed:@"city_telicon"] forState:UIControlStateNormal];
        telView.tag   = 10;
        [telView addTarget:self action:@selector(operation:) forControlEvents:UIControlEventTouchUpInside];
        _telView = telView;
        [self.toolView addSubview:_telView];
    }
    
    
    return _telView;
}

#pragma mark @@@@ ----> 拨打电话，发送短信
- (void) operation:(UIButton *)button {
    
    // 拨打电话
    if (button.tag == 10)
    {
//        [UZCommonMethod callPhone:self.telLabel.text superView:self.view];
        NSString *tel = [NSString stringWithFormat:@"tel://%@", self.telLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
    // 发送短信
    else if (button.tag == 20)
    {
        NSString *sms = [NSString stringWithFormat:@"sms://%@", self.telLabel.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sms]];
    }
}



#pragma mark @@@@ ----> 网络获取数据(获取同城详情)
- (void) getCityInfoData {
    
    
    NSString *url = connect_url(@"city_message");
    NSDictionary *dict = @{
                           @"app_key"   :url,
                           @"m_id"      :self.m_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        
        if ([param[@"code"] isEqualToString:@"200"]) {
            
            [self toolView];
            self.cityInfo = [self cityInofDataTreatment:param[@"obj"]];
            // 图片轮播
            self.cityInfoView.images = self.cityInfo.city_pic;
            
            // web 数据
            [self toUrl:self.cityInfo.message_url];
            [self toolView];

            self.nameLabel.text = self.cityInfo.contact;
            self.telLabel.text  = self.cityInfo.tel;
            [self messageView];
            [self telView];
            
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}

#pragma mark @@@@ ----> 数据处(字典转成模型数据)
- (CityInfo *) cityInofDataTreatment:(NSDictionary *)param {
    return [CityInfo objectWithKeyValues:param];
}


#pragma mark @@@@ ----> 加载 web 网页
- (void) toUrl:(NSString *)url {
    NSURL * toUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:toUrl];
    [self.webView loadRequest:request];
}


#pragma mark @@@@ ----> 代理方法 webView加载完毕之后调用
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    // 禁止选中效果
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 获取 webView 加载完毕之后的 HTML 的高度
    CGFloat webH = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    
    // 重新设置 webView 高度
    CGFloat webX = self.webView.frame.origin.x;
    CGFloat webY = self.webView.frame.origin.y;
    CGFloat webW = self.webView.frame.size.width;
    self.webView.frame = CGRectMake(webX, webY, webW, webH);
   
    // 重新设置 cityInfoView 的 contentSize 滑动高度
    CGSize size = CGSizeMake(0, CGRectGetMaxY(self.webView.frame) + 135);
    self.cityInfoView.contentSize = size;
}



@end
