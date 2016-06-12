//
//  ActivityDetailViewController.m
//  CardLeap
//
//  Created by lin on 1/9/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "UMSocial.h"
#define NaviItemTag 2016
@interface ActivityDetailViewController ()<UIWebViewDelegate,UMSocialUIDelegate>
@property (strong, nonatomic) UIWebView *activityDetailWeb;
@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.activityDetailWeb];
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
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:leftButton],mainItem];
    self.navigationItem.rightBarButtonItem=shareItem;
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    //加载网页
    if ([self isPostRequest]) {
        [self loadURLPost];
    }else{
        [self loadURLGet];
    }
}
#pragma --- mark 2016.4 在request中添加三个参数
-(void)loadURLPost
{
    NSString *user_tel=[UserModel shareInstance].user_tel;
    NSString *u_id=[UserModel shareInstance].u_id;
    NSString *session_key=[UserModel shareInstance].session_key;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL: [NSURL URLWithString:self.url]];
    request.HTTPMethod=@"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"tel=%@&u_id=%@&session_key=%@",user_tel,u_id,session_key] dataUsingEncoding:NSUTF8StringEncoding];
    [_activityDetailWeb loadRequest:request];
    NSLog(@"%@",request);
}
- (void)loadURLGet{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_activityDetailWeb loadRequest:request];
}
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
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:@"正在加载请稍等"];
    [SVProgressHUD setDefaultMaskType:1];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    NSLog(@"web页加载已结束");
}
- (void)naviItemAction:(UIBarButtonItem *)sender{
    switch (sender.tag-NaviItemTag) {
        case 1:{
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            if ([_activityDetailWeb canGoBack]) {
                
                [_activityDetailWeb goBack];
                
            }else{
                NSURL *url=[NSURL URLWithString:@""];
                NSURLRequest *request=[NSURLRequest requestWithURL:url];
                [_activityDetailWeb loadRequest:request];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case 3:{
            NSURL *url=[NSURL URLWithString:@""];
            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            [_activityDetailWeb loadRequest:request];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            [self.navigationController popViewControllerAnimated:YES];
            
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
- (void)loadURL{
     [_activityDetailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}
#pragma mark---------get UI
-(UIWebView *)activityDetailWeb
{
    if (!_activityDetailWeb) {
        _activityDetailWeb = [[UIWebView alloc] initForAutoLayout];
        _activityDetailWeb.delegate=self;
    }
    return _activityDetailWeb;
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
