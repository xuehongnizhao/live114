//
//  ZQFunctionWebController.m
//  cityo2o
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2016年 ZQ All rights reserved.
//

#import "ZQFunctionWebController.h"
#import "UserModel.h"
#import "UMSocial.h"
#import "WebViewJavascriptBridge.h"
#import "XMNPhotoPickerFramework.h"
#import "VoiceRecorderBase.h"
#import "AmrRecordWriter.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "MLAudioMeterObserver.h"
#import <AVFoundation/AVFoundation.h>
#define NaviItemTag 2016
@interface ZQFunctionWebController()<UIWebViewDelegate,UMSocialUIDelegate>
{
    NSString *_uuid;
    WVJBResponseCallback _responseCallBack;
}
@property (strong,nonatomic)UIWebView *detailWeb;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) AmrRecordWriter *amrWriter;
@property (strong, nonatomic) MLAudioRecorder *recorder;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation ZQFunctionWebController


/**
 *  页面加载完毕之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setUpLoadImageWebBridge];
    [self setUpLoadVoiceWebBridge];
    [self setLogInWebBridge];
    [self setUpLoadVoiceWebBridgeEnd];
    [self setShakeVoiceWebBridge];
    [self initRecorder];
    
}

#pragma mark --- 2016.5 添加webBridge
- (void)setShakeVoiceWebBridge{
    [self.bridge registerHandler:@"hd_playvoice" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        [self.player play];
        _responseCallBack=responseCallback;
    }];
}
- (void)setUpLoadVoiceWebBridge{
    [self.bridge registerHandler:@"hd_uploadvoicestart" handler:^(id data, WVJBResponseCallback responseCallback) {
        _uuid=data[@"uuid"];
        [self.recorder startRecording];
        _responseCallBack=responseCallback;
    }];
}
- (void)setUpLoadVoiceWebBridgeEnd{
    [self.bridge registerHandler:@"hd_uploadvoiceend" handler:^(id data, WVJBResponseCallback responseCallback) {
        _uuid=data[@"uuid"];
        [self.recorder stopRecording];
        _responseCallBack=responseCallback;
    }];
}
-(void)sendDataWithFilePath:(NSString*) filePath{

    NSString *bigArrayUrl = connect_url(as_comm);
    NSString *upVoiceURL=[bigArrayUrl stringByAppendingPathComponent:hd_upload_voice];
    NSData *voiceData=[NSData dataWithContentsOfFile:filePath];
    NSDictionary *dict = @{ 
                            @"app_key":upVoiceURL,
                            @"uuid":_uuid
                            };
    [Base64Tool postFileTo:upVoiceURL andParams:dict andFile:voiceData andFileName:@"pic" isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            _responseCallBack(@"true");
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}
- (void)setLogInWebBridge{
    [self.bridge registerHandler:@"hd_login" handler:^(id data, WVJBResponseCallback responseCallback) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        firVC.identifier = @"0";
        firVC.navigationItem.title = @"登录";
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
        _responseCallBack=responseCallback;
    }];
}
- (void)setUpLoadImageWebBridge{
    [self.bridge registerHandler:@"hd_uploadimg" handler:^(id data, WVJBResponseCallback responseCallback) {
        //    1. 推荐使用XMNPhotoPicker 的单例
        //    2. 设置选择完照片的block回调
        [XMNPhotoPicker sharePhotoPicker].frame=CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
        [XMNPhotoPicker sharePhotoPicker].maxCount=3;
        [XMNPhotoPicker sharePhotoPicker].pickingVideoEnable=NO;
        [[XMNPhotoPicker sharePhotoPicker] setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> *images, NSArray<XMNAssetModel *> *assets) {
            NSMutableArray *myImages=[NSMutableArray arrayWithArray:images];
            id image=myImages[0];
            if (myImages.count<=0||[image isKindOfClass:[XMNAssetModel class]]) {
                for (XMNAssetModel *model in assets) {
                    UIImage *image=model.originImage;
                    [myImages addObject:image];
                }
            }
            for (UIImage *image in myImages) {
                NSString *bigArrayUrl = connect_url(as_comm);
                NSString *upImageURL=[bigArrayUrl stringByAppendingPathComponent:hd_upload_img];
                NSData* imageData=UIImageJPEGRepresentation(image, 0.3);
                NSDictionary *dict = @{
                                       @"app_key":upImageURL,
                                       @"uuid":data[@"uuid"]
                                       };
                [Base64Tool postFileTo:upImageURL andParams:dict andFile:imageData andFileName:@"pic" isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                    if ([param[@"code"] integerValue]==200) {
                        responseCallback(data[@"true"]);
                    }else{
                        [SVProgressHUD showErrorWithStatus:param[@"message"]];
                    }
                } andErrorBlock:^(NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"网络异常"];
                }];
                
            }
            
        }];
        //4. 显示XMNPhotoPicker
        [[XMNPhotoPicker sharePhotoPicker] showPhotoPickerwithController:self animated:YES];
        
    }];
}
#pragma mark--------初始化录音控件
-(void)initRecorder
{
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = [VoiceRecorderBase getPathByFileName:@"record.amr"];
    NSLog(@"filePaht:%@",amrWriter.filePath);
    amrWriter.maxSecondCount = 12.0;
    amrWriter.maxFileSize = 1024*100;
    self.amrWriter = amrWriter;
    
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        DLOG(@"volume:%f",[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]);
    };
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    self.meterObserver = meterObserver;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    __weak __typeof(self)weakSelf = self;
    recorder.receiveStoppedBlock = ^{
      //发送录音
        [weakSelf sendDataWithFilePath:weakSelf.amrWriter.filePath];
        NSLog(@"停止录音代码块");
        weakSelf.meterObserver.audioQueue = nil;
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        weakSelf.meterObserver.audioQueue = nil;
        NSLog(@"错误代码块");
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    
    //amr
    recorder.bufferDurationSeconds = 0.5;
    recorder.fileWriterDelegate = self.amrWriter;
    
    self.recorder = recorder;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *userDic=@{@"tel":[UserModel shareInstance].user_tel,
                            @"u_id":[UserModel shareInstance].u_id,
                            @"session_key": [UserModel shareInstance].session_key};
    if (_responseCallBack) {
        _responseCallBack(userDic);
    }
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

-(void)setUI
{
    [self setNavBarTitle:self.title withFont:17.0f];
    [self.view addSubview:self.detailWeb];
#pragma mark --- 2016.4 添加关闭，返回，主页，分享
    UIButton *backItem = [UIButton buttonWithType:UIButtonTypeCustom];
    backItem.frame = CGRectMake(0, 0, 40, 40);
    backItem.imageEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);//　　设置按钮图片的偏移位置(向左偏移)
    [backItem setImage:[UIImage imageNamed:@"shake_back"] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    backItem.tag=NaviItemTag+1;
    
    UIButton *closeItem = [UIButton buttonWithType:UIButtonTypeCustom];
    closeItem.frame = CGRectMake(0, 0, 40, 40);
    closeItem.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);//　　设置按钮图片的偏移位置(向左偏移)
    [closeItem setImage:[UIImage imageNamed:@"web_back"] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.tag=NaviItemTag+2;
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithCustomView:shareButton];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(naviItemAction:) forControlEvents:UIControlEventTouchUpInside];
    shareButton.tag=NaviItemTag+3;
    self.navigationItem.leftBarButtonItems=@[[[UIBarButtonItem alloc]initWithCustomView:backItem], [[UIBarButtonItem alloc]initWithCustomView:closeItem]];
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
            NSURL *url=[NSURL URLWithString:@""];
            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            [_detailWeb loadRequest:request];
            [[NSURLCache sharedURLCache] removeAllCachedResponses];
            [[NSURLCache sharedURLCache] setDiskCapacity:0];
            [[NSURLCache sharedURLCache] setMemoryCapacity:0];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 3:{
            
            
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
#pragma --- mark 2016.4 在request中添加三个参数
-(void)loadURLPost
{
    NSString *user_tel=[UserModel shareInstance].user_tel;
    NSString *u_id=[UserModel shareInstance].u_id;
    NSString *session_key=[UserModel shareInstance].session_key;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL: [NSURL URLWithString:self.url]];
    request.HTTPMethod=@"POST";
    if (self.shop_id) {
    request.HTTPBody = [[NSString stringWithFormat:@"tel=%@&u_id=%@&session_key=%@&shop_id=%@",user_tel,u_id,session_key,self.shop_id] dataUsingEncoding:NSUTF8StringEncoding];
        [_detailWeb loadRequest:request];
        return;
    }
    request.HTTPBody = [[NSString stringWithFormat:@"tel=%@&u_id=%@&session_key=%@",user_tel,u_id,session_key] dataUsingEncoding:NSUTF8StringEncoding];
    [_detailWeb loadRequest:request];
    NSLog(@"%@",request);
}
- (void)loadURLGet{
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_detailWeb loadRequest:request];
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
    /*
     判断当前网络环境
     */
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:{
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }
            break;
        default:{
            [SVProgressHUD showWithStatus:@"正在加载请稍等"];
            [SVProgressHUD setDefaultMaskType:1];
        }
            break;
    }

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    NSLog(@"web页加载已结束");
}

#pragma mark-----get UI
-(UIWebView *)detailWeb
{
    if (!_detailWeb) {
        _detailWeb = [[UIWebView alloc] initForAutoLayout];
        if ([self isPostRequest]) {
            [self loadURLPost];
        }else{
            [self loadURLGet];
        }
    }
    return _detailWeb;
}
- (WebViewJavascriptBridge *)bridge{
    if (!_bridge) {
        _bridge=[WebViewJavascriptBridge bridgeForWebView:self.detailWeb];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

- (AVAudioPlayer *)player{
    if (!_player) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"shake_sound" ofType:@"m4a"];
        NSURL *url=[NSURL fileURLWithPath:path];
        _player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }
    return _player;
}
@end
