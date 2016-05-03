//
//  CouponDetailViewController.m
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "CouponDetailViewController.h"
#import "SpikeCodeViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"

@interface CouponDetailViewController ()<UIWebViewDelegate,UMSocialDataDelegate>
@property (strong, nonatomic) UIView *operationView;
@property (strong, nonatomic) UIWebView *spikeDetailWeb;
@property (strong, nonatomic) UIButton *downloadButton;
@property (strong, nonatomic) UILabel *messageLable;
@property (strong, nonatomic) UIButton *shareButton;
@end

@implementation CouponDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.info != nil) {
        [self freshDataFromNet];
    }
}

#pragma mark--------------刷新数据
-(void)freshDataFromNet
{
    NSString *url = connect_url(@"spike_down");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"spike_id":self.info.spike_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            self.info.down = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"down"]];
            _messageLable.text = [NSString stringWithFormat:@"剩余%@张，%@人已下载",self.info.spike_lastnum,self.info.down];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络一场"];
    }];
}

#pragma mark--------------set UI
-(void)setUI
{

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem = rightBar;


    [self.view addSubview:self.spikeDetailWeb];
    [_spikeDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_spikeDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_spikeDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_spikeDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_spikeDetailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.message_url]]];
    
    if(self.info !=nil){
        [self.view addSubview:self.operationView];
        [_operationView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [_operationView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        [_operationView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [_operationView autoSetDimension:ALDimensionHeight toSize:45.0f];
        
        [_operationView addSubview:self.messageLable];
        [_operationView addSubview:self.downloadButton];
        [_downloadButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [_downloadButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_downloadButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_downloadButton autoSetDimension:ALDimensionWidth toSize:100.0f];
        
        [_messageLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [_messageLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_messageLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_messageLable autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_downloadButton withOffset:-15.0f];
        _messageLable.text = [NSString stringWithFormat:@"剩余%@张，%@人已下载",self.info.spike_lastnum,self.info.down];
    }else{
        //
    }
}

#pragma mark--------------get UI
-(UIView *)operationView
{
    if (!_operationView) {
        _operationView = [[UIView alloc] initForAutoLayout];
        _operationView.backgroundColor = [UIColor whiteColor];
        _operationView.layer.borderWidth = 0.5f;
        _operationView.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    }
    return _operationView;
}

-(UIWebView *)spikeDetailWeb
{
    if (!_spikeDetailWeb) {
        _spikeDetailWeb = [[UIWebView alloc] initForAutoLayout];
        _spikeDetailWeb.backgroundColor = [UIColor whiteColor];
    }
    return _spikeDetailWeb;
}

-(UIButton *)downloadButton
{
    if (!_downloadButton) {
        _downloadButton = [[UIButton alloc] initForAutoLayout];
        [_downloadButton setBackgroundColor:UIColorFromRGB(0xcd4350)];
        _downloadButton.layer.masksToBounds = YES;
        _downloadButton.layer.cornerRadius = 4.0f;
        _downloadButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTitle:@"下载" forState:UIControlStateHighlighted];
        [_downloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

-(UILabel *)messageLable
{
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] initForAutoLayout];
        _messageLable.font = [UIFont systemFontOfSize:14.0f];
        _messageLable.textColor = UIColorFromRGB(singleTitle);
    }
    return _messageLable;
}

-(UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareActino:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.imageEdgeInsets =  UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _shareButton;
}

#pragma mark---------------click action
-(void)downloadAction:(UIButton*)sender
{
    NSLog(@"下载优惠券");
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"登录"];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        NSString *url = connect_url(@"seckill");
        NSDictionary *dic = @{
                              @"app_key":url,
                              @"u_id":[UserModel shareInstance].u_id,
                              @"session_key":[UserModel shareInstance].session_key,
                              @"spike_id":self.info.spike_id
                              };
        [SVProgressHUD showWithStatus:@"正在努力为您抢购" maskType:SVProgressHUDMaskTypeNone];
        [Base64Tool postSomethingToServe:url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                NSInteger type = [[param[@"obj"] objectForKey:@"type"] integerValue];
                if (type == 0) {
                    [SVProgressHUD dismiss];
                    NSString *spike_code = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"spike_pass"]];
                    SpikeCodeViewController *firVC = [[SpikeCodeViewController alloc] init];
                    [firVC setHiddenTabbar:YES];
                    firVC.info = self.info;
                    firVC.spike_code = spike_code;
                    [firVC setNavBarTitle:self.info.spike_name withFont:14.0f];
//                    [firVC.navigationItem setTitle:self.info.spike_name];
                    [self.navigationController pushViewController:firVC animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:param[@"message"]];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

-(void)shareActino:(UIButton*)sender
{
    NSLog(@"点击分享");
    [self UserSharePoint];
    //NSString *url = @"www.baidu.com";
    NSString *sinaText;
    sinaText = [NSString stringWithFormat:@"如e生活 %@",self.share_url];

    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = self.myInfo.spike_name;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.share_url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.myInfo.spike_name;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.share_url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = self.myInfo.spike_name;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.share_url;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaText;
}
#pragma mark --- 11.28 点击分享按钮就加积分
- (void) UserSharePoint {
    if (ApplicationDelegate.islogin == YES) {
        NSString *url = connect_url(@"share_point");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"u_id":[UserModel shareInstance].u_id
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
//                [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"您尚未登录，无法给您增加积分"];
    }
}
#pragma mark--------分享回掉方法（弃用）
-(void)didFinishGetUMSocialDataInViewController1:(UMSocialResponseEntity *)response
{
    NSLog(@"分享完成，去执行接口增加积分");
    NSLog(@"进入代理方法");
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        if (ApplicationDelegate.islogin == YES) {
            NSString *url = connect_url(@"share_point");
            NSDictionary *dict = @{
                                   @"app_key":url,
                                   @"u_id":[UserModel shareInstance].u_id
                                   };
            [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                if ([param[@"code"] integerValue]==200) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                }
            } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"您尚未登录，无法给您增加积分"];
        }
    }
    else if (response.responseCode == UMSResponseCodeFaild){
        [SVProgressHUD showSuccessWithStatus:@"分享失败"];
    }
}

#pragma mark--------webview delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成，开始追入数据");
}

/*
#pragma mark - Navigation
// In a  -based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
