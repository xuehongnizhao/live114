//
//  ZQFunctionWebViewController.m
//  cityo2o
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "ZQFunctionWebViewController.h"
#import "UserModel.h"
#import "UMSocial.h"
#import "WebViewJavascriptBridge.h"
#import "LoginViewController.h"
#define NaviItemTag 2016
@interface ZQFunctionWebViewController()<UIWebViewDelegate,UMSocialUIDelegate>
{
    NSString *_uuid;
    WVJBResponseCallback _responseCallBack;
}
@property (strong,nonatomic)UIWebView *detailWeb;

@end

@implementation ZQFunctionWebViewController
/**
 *  页面加载完毕之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

-(void)setUI
{
    [self setNavBarTitle:self.title withFont:17.0f];
    [self.view addSubview:self.detailWeb];
#pragma mark --- 2016.4 添加关闭，返回，主页，分享
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 32, 26);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);//　　设置按钮图片的偏移位置(向左偏移)
    [leftButton setImage:[UIImage imageNamed:@"shake_back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.tag=NaviItemTag+1;
    UIBarButtonItem *mainItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    mainItem.tag=NaviItemTag+3;
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithCustomView:shareButton];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag=NaviItemTag+4;
    
//    //    self.navigationItem.leftBarButtonItems=@[closeItem,backItem];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftButton],mainItem];
    self.navigationItem.rightBarButtonItem=shareItem;
    
    
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
}

- (void)naviItemAction:(UIBarButtonItem *)sender{
    switch (sender.tag-NaviItemTag) {
        case 1:{
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            if ([_detailWeb canGoBack]) {
                
                [_detailWeb goBack];
                
            }else{
                NSURL *url=[NSURL URLWithString:@""];
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                [_detailWeb loadRequest:request];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 2:{
            //            NSURL *url=[NSURL URLWithString:@""];
            //            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            //            [_detailWeb loadRequest:request];
            //            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 3:{
            NSURL *url=[NSURL URLWithString:@""];
            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            [_detailWeb loadRequest:request];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            [self.navigationController popViewControllerAnimated:YES];
            
            //            if ([self isPostRequest]) {
            //                [self loadURLPost];
            //            }else{
            //                [self loadURLGet];
            //            }
        }
            break;
        case 4:{
            
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:nil
                                              shareText:@"如e生活"
                                             shareImage:[UIImage imageNamed:@"shareIcon"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                               delegate:self];
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = self.title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
            
            [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
            [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
            
            [UMSocialData defaultData].extConfig.sinaData.shareText = self.title;
            //            [UMSocialData defaultData].extConfig.sinaData.url= self.url;
            
        }
            break;
            
        default:
            break;
    }
}
#pragma --- mark 2016.4 在request中}
- (BOOL)isPostRequest{
    NSArray *urlFilters=[[NSUserDefaults standardUserDefaults]objectForKey:URLFilter];
    for (NSDictionary *dic in urlFilters) {
        NSString *string=dic[@"url"];
        if ([self.url rangeOfString:string].location!=NSNotFound) {
            return YES;
        }
    }
    return NO;
}
#pragma --- mark 2016.4 在request中添加三个参数
-(void)loadURLPost
{
    
    NSString *user_tel=[UserModel shareInstance].user_tel;
    NSString *u_id=[UserModel shareInstance].u_id;
    NSString *session_key=[UserModel shareInstance].session_key;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL: [NSURL URLWithString:self.url]];
    request.HTTPMethod=@"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"tel=%@&u_id=%@&session_key=%@&shop_id=%@",user_tel,u_id,session_key,self.shop_id] dataUsingEncoding:NSUTF8StringEncoding];
    [_detailWeb loadRequest:request];
    NSLog(@"%@",request);
}

- (void)loadURLGet{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_detailWeb loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web页加载已结束");
}

#pragma mark-----get UI
-(UIWebView *)detailWeb
{
    if (!_detailWeb) {
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        _detailWeb.delegate = self;
        if ([self isPostRequest]) {
            [self loadURLPost];
        }else{
            [self loadURLGet];
        }
    }
    return _detailWeb;
}
@end
