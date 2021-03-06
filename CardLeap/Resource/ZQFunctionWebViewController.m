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
#import "XMNPhotoPickerFramework.h"
#import "VoiceRecorderBase.h"
#import "AmrRecordWriter.h"
#import "VoiceView.h"
#import "LoginViewController.h"
#import "UserModel.h"
#import "MLAudioMeterObserver.h"
#define NaviItemTag 2016
@interface ZQFunctionWebViewController()<UIWebViewDelegate,UMSocialUIDelegate>
{
    NSString *_uuid;
    WVJBResponseCallback _responseCallBack;
}
@property (strong,nonatomic)UIWebView *detailWeb;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;
@property (strong, nonatomic) AmrRecordWriter *amrWriter;
@property (strong, nonatomic) MLAudioRecorder *recorder;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;
@end

@implementation ZQFunctionWebViewController
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
    [self initRecorder];
    
}

#pragma mark --- 2016.5 添加webBridge

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
        //[weakSelf.recordButton setTitle:@"Record" forState:UIControlStateNormal];
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
    
    
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_detailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    
}

- (void)naviItemAction:(UIBarButtonItem *)sender{
    switch (sender.tag-NaviItemTag) {
        case 1:{
            
            [_detailWeb goBack];
        }
            break;
        case 2:{
            [self.navigationController popViewControllerAnimated:YES];
            
        }
            break;
        case 3:{
            if ([self isPostRequest]) {
                [self loadURLPost];
            }else{
                [self loadURLGet];
            }
          
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

- (WebViewJavascriptBridge *)bridge{
    if (!_bridge) {
        _bridge=[WebViewJavascriptBridge bridgeForWebView:self.detailWeb];
    }
    return _bridge;
}
@end
