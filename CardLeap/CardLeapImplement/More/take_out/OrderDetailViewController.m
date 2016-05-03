//
//  OrderDetailViewController.m
//  CardLeap
//
//  Created by lin on 1/5/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "RviewDishListViewController.h"
#import "UMSocial.h"

@interface OrderDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{
    NSString *delete_order_id;
    NSString *timely ;
    NSString *confirmId ;
    NSString *confirmStatus;
    //    NSTimer *timer;
    NSMutableArray *dishArray;
    //call phone web
    UIWebView *phoneWeb;
    NSMutableArray *phoneNumberArray;
    NSString *share_url;
}
@property (strong, nonatomic) UIWebView *orderDetailWeb;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark --- 2015.12.24 删除web页间隔自动刷新功能。
    [self setUI];
    [self loadHTML];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----------get Data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"takeout_status_message");
    NSDictionary *dict = @{
                           @"order_id":self.order_id,
                           @"app_key":url
                           };
    [SVProgressHUD showWithStatus:@"正在加载订单" maskType:SVProgressHUDMaskTypeClear];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            //----get share_url-------------------
            share_url = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"share_url"]];
            //----save dishes array---------------
            dishArray = [[NSMutableArray alloc] init ];
            NSArray *arr = [param[@"obj"] objectForKey:@"order_desc"];
            for (NSDictionary *dict in arr) {
                [dishArray addObject:dict];
            }
            //----pass data to html test----------
            NSMutableDictionary *dic = (NSMutableDictionary*)param;
            NSString *methodContent=[dic jsonEncodedKeyValueString];
            NSString *info = [NSString stringWithFormat:@"%@(%@)",@"takeout_message",methodContent];
            //拼接html的web数据
            [_orderDetailWeb stringByEvaluatingJavaScriptFromString:info];
            if ([[param[@"obj"] objectForKey:@"comfirm_status"] integerValue]==5 || [[param[@"obj"] objectForKey:@"comfirm_status"] integerValue]==3) {
                //                [timer invalidate];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)updateMessageForOrder
{
    NSString *url = connect_url(@"takeout_status_message");
    NSDictionary *dict = @{
                           @"order_id":self.order_id,
                           @"app_key":url
                           };
    //[SVProgressHUD showWithStatus:@"正在刷新订单" maskType:SVProgressHUDMaskTypeClear];
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            //----pass data to html test----------
            NSMutableDictionary *dic = (NSMutableDictionary*)param;
            NSString *methodContent=[dic jsonEncodedKeyValueString];
            NSString *info = [NSString stringWithFormat:@"%@(%@)",@"takeout_message_two",methodContent];
            //拼接html的web数据
            [_orderDetailWeb stringByEvaluatingJavaScriptFromString:info];
            if ([[param[@"obj"] objectForKey:@"comfirm_status"] integerValue]==5 || [[param[@"obj"] objectForKey:@"comfirm_status"] integerValue]==3) {
                //                [timer invalidate];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----------load html
-(void)loadHTML
{
    //    NSString *htmlStr = @"takeout_status_message.html";
    //    _orderDetailWeb.scrollView.showsVerticalScrollIndicator = NO;
    //    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:htmlStr ofType:nil];
    //    NSURL *url=[NSURL fileURLWithPath:htmlPath];
    //    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //    _orderDetailWeb.scalesPageToFit=NO;
    //    [_orderDetailWeb loadRequest:request];
    _orderDetailWeb.scrollView.showsVerticalScrollIndicator = NO;
    NSURL *url = [NSURL URLWithString:self.takeout_url];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    _orderDetailWeb.scalesPageToFit = NO;
    [_orderDetailWeb loadRequest:request];
}

#pragma mark-----------get UI
-(UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(-20, -20, 0, 20);
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateHighlighted];
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UIWebView *)orderDetailWeb
{
    if (!_orderDetailWeb) {
        _orderDetailWeb = [[UIWebView alloc] initForAutoLayout];
        _orderDetailWeb.backgroundColor = [UIColor whiteColor];
        _orderDetailWeb.delegate = self;
    }
    return _orderDetailWeb;
}

-(UIButton *)shareButton·
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_shareButton setImage:[UIImage imageNamed:@"navtakeout_send_no"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"navtakeout_send_sel"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

#pragma mark-----------set UI
-(void)setUI
{
    [self.view addSubview:self.orderDetailWeb];
    [_orderDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_orderDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_orderDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeTop  withInset:0.0f];
    [_orderDetailWeb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
    if (![self.identifier isEqualToString:@"1"]) {
        //set back button
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        self.navigationItem.leftBarButtonItem = leftBar;
    }
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    //[self initTimer];
}
#pragma mark-----------set timer
-(void)initTimer
{
    //    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateOrderState) userInfo:nil repeats:YES];
}

-(void)updateOrderState
{
    //    [self updateMessageForOrder];
    [self loadHTML];
}

#pragma mark-----------webview delegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSLog(@"scheme:%@",url.scheme);
    if([url.scheme isEqualToString:@"review"]){
        // 弹出评价页面
        [self goToReview];
    }
    return YES;
#pragma mark --- 11.26日 取消大多数的交互操作，只留一个“评价”按钮的web交互
    //    NSString *requestString = [[request URL] absoluteString];
    //    NSArray *components = [requestString componentsSeparatedByString:@":"];
    //
    //    NSLog(@"components==%@",components);
    //
    //    if ([components count] > 1 && [components[0] isEqualToString:@"testapp"])
    //    {
    //        if ([components[1] isEqualToString:@"order_id"]){
    //            timely = @"0";
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否及时送达" delegate:self cancelButtonTitle:@"及时" otherButtonTitles:@"不及时", nil];
    //            alert.tag = 2;
    //            [alert show];
    //            confirmId = components[2];
    //            confirmStatus = components[3];
    //        }else if ([components[1] isEqualToString:@"delete_order_id"]){
    //            NSString *order_id = components[2];
    //            NSString *status = components[3];
    //            delete_order_id = order_id;
    //            if ([status integerValue]==0) {
    //               [self deleteOrder:order_id];
    //            }else{
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"商家已经确认,取消订单可能需要等待审核" delegate:self cancelButtonTitle:@"确认取消" otherButtonTitles:@"不了", nil];
    //                alert.tag = 1;
    //                [alert show];
    //            }
    //        }else if ([components[1] isEqualToString:@"phone"]){
    //            NSString *phone_num = components[2];
    //            NSArray *phoneArray = [phone_num componentsSeparatedByString:@","];
    //            if ([phoneArray count]>1) {
    //
    //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:phoneArray[0],phoneArray[1], nil];
    //                alert.tag = 3;
    //                phoneNumberArray = [[NSMutableArray alloc] initWithArray:phoneArray];
    //                [alert show];
    //
    //            }else{
    //                [self call_phone:[phoneArray objectAtIndex:0]];
    //            }
    //
    //        }else if ([components[1] isEqualToString:@"review"]){
    //            [self goToReview];
    //        }
    //    }
    //    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"加载完成");
    //    [self getDataFromNet];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}

#pragma mark-----------alertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self deleteOrder:delete_order_id];
        }
    }else if(alertView.tag == 2){
        if (buttonIndex == 0) {
            timely = @"0";
        }else{
            timely = @"1";
        }
        [self confirmOrder:confirmId status:confirmStatus];
    }else if (alertView.tag == 3){
        if (buttonIndex == 1) {
            [UZCommonMethod callPhone:phoneNumberArray[0] superView:self.view];
        }else if (buttonIndex == 2){
            [UZCommonMethod callPhone:phoneNumberArray[1] superView:self.view];
        }
    }
}

#pragma mark-----------button action
-(void)shareAction:(UIButton*)sender
{
    NSLog(@"分享订单");
    if (share_url != nil) {
        NSString *url = share_url;
        NSString *sinaText = [NSString stringWithFormat:@"如e生活 %@",url];
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:sinaText
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToSms]
                                           delegate:self];
        
        //    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"城市o2o";
        //    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
        //
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"如e生活";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    }
    //
    //    [UMSocialData defaultData].extConfig.qzoneData.title = @"城市o2o";
    //    [UMSocialData defaultData].extConfig.qzoneData.url = url;
    //
    //    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaText;
}

-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response
{
    NSLog(@"分享成功");
}

-(void)backAction:(UIButton*)sender
{
    NSLog(@"返回主界面");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark-----------order function
-(void)deleteOrder:(NSString*)order_id
{
    NSString *url = connect_url(@"del_status");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"order_id":order_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            [self updateMessageForOrder];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)confirmOrder:(NSString*)order_id status :(NSString*)status
{
    NSString *url = connect_url(@"update_status");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"order_id":order_id,
                           @"confirm_status":status,
                           @"timely":timely
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            //            [timer invalidate];
            [self updateMessageForOrder];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

-(void)call_phone:(NSString*)phone_num
{
    //[UZCommonMethod callPhone:phone_num superView:self.view];
    NSString *phoneNumber = phone_num;// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
    phoneWeb=[[UIWebView alloc]init];
    if ( !phoneWeb ) {
        phoneWeb = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneWeb loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

-(void)goToReview
{
    RviewDishListViewController *firVC = [[RviewDishListViewController alloc] init];
    [firVC setNavBarTitle:@"待评价菜品" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"待评价菜品"];
    firVC.order_id = self.order_id;
    [self.navigationController pushViewController:firVC animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //    [timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [self initTimer];
    [self updateOrderState];
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
