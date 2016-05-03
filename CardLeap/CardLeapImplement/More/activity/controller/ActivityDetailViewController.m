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
    // Do any additional setup after loading the view.
    //[self setHiddenTabbar:YES];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.activityDetailWeb];
#pragma mark --- 2016.4 添加关闭，返回，主页，分享
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    backItem.tag=NaviItemTag +1;
    UIBarButtonItem *closeItem=[[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    closeItem.tag=NaviItemTag +2;
    UIBarButtonItem *mainItem=[[UIBarButtonItem alloc]initWithTitle:@"主页" style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    mainItem.tag=NaviItemTag+3;
    //    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithCustomView:shareButton];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"coupon_share_no"] style:UIBarButtonItemStylePlain target:self action:@selector(naviItemAction:)];
    shareButton.tag=NaviItemTag+4;
    self.navigationItem.leftBarButtonItems=@[closeItem,backItem];
    self.navigationItem.rightBarButtonItems=@[shareItem,mainItem];
    
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_activityDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    //加载网页
    [self loadURL];
}
- (void)naviItemAction:(UIBarButtonItem *)sender{
    switch (sender.tag-NaviItemTag) {
        case 1:{
            
            [_activityDetailWeb goBack];
        }
            break;
        case 2:{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 3:{
            
            [self loadURL];
        }
            break;
        case 4:{
            
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:nil
                                              shareText:@"如e生活"
                                             shareImage:[UIImage imageNamed:@"shareIcon"]
                                        shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                               delegate:self];
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"详情";
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.url;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"详情";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = self.url;
            
            [UMSocialData defaultData].extConfig.qzoneData.title = @"详情";
            [UMSocialData defaultData].extConfig.qzoneData.url = self.url;
            
            [UMSocialData defaultData].extConfig.sinaData.shareText = @"详情";
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
