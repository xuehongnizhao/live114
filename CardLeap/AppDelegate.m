//
//  AppDelegate.m
//  CardLeap
//
//  Created by Sky on 14/11/20.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "AppDelegate.h"
//加载ttf字体
#import "FontManager.h"
//navbar
#import "DSNavigationBar.h"
//tabBar
#import "TabBarViewController.h"
#import "JsonModel.h"
//极光推送
#import "APService.h"
//友盟社会化组件
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>
//推送接收跳转页面
#import "MessageViewController.h"
#import "ActivityDetailViewController.h"
#import "mySeatSuccessViewController.h"
#import "myRoomSuccessViewController.h"
#import "OrderDetailViewController.h"
#import "OrderSeatViewController.h"
#import "orderRoomListViewController.h"
//消息按钮界面
#import "HomeNavigationView.h"

#import "AppUpdatesController.h"    //APP更新链接
#define AppVersion @"AppVersion"    //APP版本号

@interface AppDelegate ()<UIAlertViewDelegate>
@property (strong,nonatomic) UIImageView *image;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *url;
@property(nonatomic,strong)UIViewController* viewController;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //    sleep(2);
    // Override point for customization after application launch.
    // 项目版本号--一次调用
    self.applicationVersion = [UZCommonMethod checkAPPVersion];
    
    // 判断系统版本--一次调用
    self.systemVersion = [UZCommonMethod checkSystemVersion];
    
    // 设置网路引擎
    self.baseEngine = [[BaseEngine alloc] initWithHostName:baseUrl];
    //-----------设置友盟---------------
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxadf37d5562adeb69" appSecret:@"6ad21a458d3ebebfa0dc34242760cbcf" url:@"http://www.114lives.com"];
    
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    // QQ分享
    [UMSocialQQHandler setQQWithAppId:@"1104763572" appKey:@"LU37ehGMxcMGrjRN" url:@"http://www.114lives.com"];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    self.window.tintColor = [UIColor whiteColor];
    //    self.window.backgroundColor = [UIColor whiteColor];
    //    self.window.userInteractionEnabled = YES;
    
    //-----------极光推送----------------------
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    [application setApplicationIconBadgeNumber:0];
    
    //修改HUD背景颜色和字体颜色
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
//    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.8]];
//    [[SVProgressHUD appearance] setHudForegroundColor:[UIColor whiteColor]];
    //加载字体
    [[FontManager sharedManager] loadFont:@"Aller_Lt"];
    [[FontManager sharedManager] loadFont:@"OpenSans-Light"];
    //crush 回调函数
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    //自定义设置欢迎页面
    _image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    _image.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _image.userInteractionEnabled = YES;
    [self.window addSubview:_image];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UIViewController alloc] init];
    //读取基础接口
    [self getDataFromNet];
    //[self setIndex];
    //[self sendCrushMessage];
    return YES;
}

-(void)test
{
    NSLog(@"111");
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
}

#pragma mark---------设备号获取以及回调函数
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}
// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

#pragma mark------收到通知回调
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    if (application.applicationState == UIApplicationStateActive) {
        NSString *string = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:string
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 3;
        [alertView show];
        
        //程序大模块之后会添加有关推送的逻辑
        TabBarViewController *firVC  = (TabBarViewController*)self.window.rootViewController;
        NSInteger index = firVC.selectedIndex;
        BaseViewController *indexViewController = [firVC.viewControllers objectAtIndex:index];
        UIViewController *currentViewCtrl = ((UINavigationController*)indexViewController).topViewController;
        /**
         type = 1  公告
         type = 2  朋友圈回复
         */
        self.type = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"type"]];
        self.url = [userInfo objectForKey:@"url"];
        NSInteger my_type = [[userInfo objectForKey:@"type"] integerValue];
        if (my_type == 1) {//公告
            NSString *message_url = [userInfo objectForKey:@"url"];
            if (![currentViewCtrl isKindOfClass:[ActivityDetailViewController class]]) {
                ActivityDetailViewController *message = [[ActivityDetailViewController alloc] init];
                message.url = message_url;
                [firVC setTabBarHidden:YES animated:YES];
                [message setNavBarTitle:@"公告详情" withFont:14.0f];
                [currentViewCtrl.navigationController pushViewController:message animated:YES];
            }
        }else if(my_type == 2){//朋友圈回复
            NSString *count = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"num"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ISNEWREPLY" object:count];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CIRCLE_NEW_MESSAGE" object:count];
        }else if (my_type == 3){//预定酒店
            NSString *room_id =[userInfo objectForKey:@"id"];
            if (room_id == nil) {
                room_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[myRoomSuccessViewController class]]) {
                myRoomSuccessViewController *RoomViewController = [[myRoomSuccessViewController alloc] init];
                [RoomViewController setNavBarTitle:@"商家确认" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                RoomViewController.identifier = @"1";
                RoomViewController.room_id = room_id;
                [currentViewCtrl.navigationController pushViewController:RoomViewController animated:YES];
            }
        }else if (my_type == 4){//预定座位
            NSString *seat_id =[userInfo objectForKey:@"id"];
            if (seat_id == nil) {
                seat_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[mySeatSuccessViewController class]]) {
                mySeatSuccessViewController *SeatViewController = [[mySeatSuccessViewController alloc] init];
                [SeatViewController setNavBarTitle:@"商家确认" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                SeatViewController.seat_id = seat_id;
                [currentViewCtrl.navigationController pushViewController:SeatViewController animated:YES];
            }
        }else if (my_type == 5){//订外卖
            NSString *order_id =[userInfo objectForKey:@"id"];
            if (order_id == nil) {
                order_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[OrderDetailViewController class]]) {
                OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
                [orderDetailViewController setNavBarTitle:@"订单详情" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                orderDetailViewController.order_id = order_id;
                orderDetailViewController.identifier =@"1";
                [currentViewCtrl.navigationController pushViewController:orderDetailViewController animated:YES];
            }
        }else if (my_type == 6){//取消酒店
            if (![currentViewCtrl isKindOfClass:[orderRoomListViewController class]]) {
                orderRoomListViewController *roomViewController = [[orderRoomListViewController alloc] init];
                [firVC setTabBarHidden:YES animated:YES];
                [roomViewController setNavBarTitle:@"订酒店" withFont:14.0f];
                [currentViewCtrl.navigationController pushViewController:roomViewController animated:YES];
            }
        }else if (my_type == 7){//取消订座
            OrderSeatViewController *seatViewController = [[OrderSeatViewController alloc] init];
            [seatViewController setNavBarTitle:@"订座位" withFont:14.0f];
            [firVC setTabBarHidden:YES animated:YES];
            [currentViewCtrl.navigationController pushViewController:seatViewController animated:YES];
        }
    }else{
        //程序大模块之后会添加有关推送的逻辑
        TabBarViewController *firVC  = (TabBarViewController*)self.window.rootViewController;
        NSInteger index = firVC.selectedIndex;
        BaseViewController *indexViewController = [firVC.viewControllers objectAtIndex:index];
        UIViewController *currentViewCtrl = ((UINavigationController*)indexViewController).topViewController;
        
        /**
         type = 1  公告
         */
        NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
        if (type == 1) {//公告
            NSString *message_url = [userInfo objectForKey:@"url"];
            if (![currentViewCtrl isKindOfClass:[ActivityDetailViewController class]]) {
                ActivityDetailViewController *message = [[ActivityDetailViewController alloc] init];
                message.url = message_url;
                [firVC setTabBarHidden:YES animated:YES];
                [message setNavBarTitle:@"公告详情" withFont:14.0f];
                [currentViewCtrl.navigationController pushViewController:message animated:YES];
            }
        }else if(type == 2){
            NSString *count = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"num"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ISNEWREPLY" object:count];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CIRCLE_NEW_MESSAGE" object:count];
        }else if (type == 3){
            NSString *room_id =[userInfo objectForKey:@"id"];
            if (room_id == nil) {
                room_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[myRoomSuccessViewController class]]) {
                myRoomSuccessViewController *RoomViewController = [[myRoomSuccessViewController alloc] init];
                [RoomViewController setNavBarTitle:@"商家确认" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                RoomViewController.identifier = @"1";
                RoomViewController.room_id = room_id;
                [currentViewCtrl.navigationController pushViewController:RoomViewController animated:YES];
            }
        }else if (type == 4){
            NSString *seat_id =[userInfo objectForKey:@"id"];
            if (seat_id == nil) {
                seat_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[mySeatSuccessViewController class]]) {
                mySeatSuccessViewController *SeatViewController = [[mySeatSuccessViewController alloc] init];
                [SeatViewController setNavBarTitle:@"商家确认" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                SeatViewController.seat_id = seat_id;
                [currentViewCtrl.navigationController pushViewController:SeatViewController animated:YES];
            }
        }else if (type == 5){
            NSString *order_id =[userInfo objectForKey:@"id"];
            if (order_id == nil) {
                order_id = @"12";
            }
            if (![currentViewCtrl isKindOfClass:[OrderDetailViewController class]]) {
                OrderDetailViewController *orderDetailViewController = [[OrderDetailViewController alloc] init];
                [orderDetailViewController setNavBarTitle:@"订单详情" withFont:14.0f];
                [firVC setTabBarHidden:YES animated:YES];
                orderDetailViewController.order_id = order_id;
                orderDetailViewController.identifier =@"1";
                [currentViewCtrl.navigationController pushViewController:orderDetailViewController animated:YES];
            }
        }else if (type == 6){//取消酒店
            if (![currentViewCtrl isKindOfClass:[orderRoomListViewController class]]) {
                orderRoomListViewController *roomViewController = [[orderRoomListViewController alloc] init];
                [firVC setTabBarHidden:YES animated:YES];
                [roomViewController setNavBarTitle:@"订酒店" withFont:14.0f];
                [currentViewCtrl.navigationController pushViewController:roomViewController animated:YES];
            }
        }else if (type == 7){//取消订座
            OrderSeatViewController *seatViewController = [[OrderSeatViewController alloc] init];
            [seatViewController setNavBarTitle:@"订座位" withFont:14.0f];
            [firVC setTabBarHidden:YES animated:YES];
            [currentViewCtrl.navigationController pushViewController:seatViewController animated:YES];
        }
        
    }
    [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark----设置别名
-(void)setAlian :(NSString*)alian
{
    [APService setTags:nil
                 alias:alian
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
}

#pragma mark------获取设备id
- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    if ([APService registrationID]) {
        self.deviceID = [APService registrationID];
        [[NSUserDefaults standardUserDefaults] setObject:self.deviceID forKey:@"baidu_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"get RegistrationID");
        [self AutoLogin];
    }else{
        [self AutoLogin];
    }
}

#pragma mark---------get ac_base data
-(void)getDataFromNet
{
    NSString *sys_type = [[UIDevice currentDevice] systemName];
    NSString *sys_version = [[UIDevice currentDevice] systemVersion];
    NSString *device_type = @"iPhone";
    NSString *brand =@"苹果";
    NSString *model = [[UIDevice currentDevice] model]  ;
    NSString *lat = @"126.650516";
    NSString *lng = @"45.759086";
    NSString *u_id = @"0";
    
    NSDictionary *paramDic = @{@"sys_type":    sys_type,
                               @"sys_version": sys_version,
                               @"device_type": device_type,
                               @"brand":       brand,
                               @"model":       model,
                               @"app_key":     base_set,
                               @"lat":         lat,
                               @"lng":         lng,
                               @"u_id":        u_id
                               };
    [Base64Tool postSomethingToServe:base_set andParams:paramDic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSLog(@"%@",param);
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            if ([JSONOfNetWork createPlist:param]){
                NSLog(@"写入完成了，该干什么就干什么吧");
                [self setIndex];//暂时不做
                //                [self checkVersion];
            }
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
}
#pragma mark------自动登录
-(void)AutoLogin
{
    if (ApplicationDelegate.islogin == NO) {
        if ([userDefault(@"AUTOLOGIN") isEqualToString:@"YES"]) {
            NSString *userName = userDefault(@"USERNAME");
            NSString *passWord = userDefault(@"PASSWORD");
            NSString *baidu_id = userDefault(@"baidu_id");
            if (baidu_id==nil || baidu_id.length == 0) {
                baidu_id = @"0";
            }
            NSString *url = @"user/ac_user/yz_login";
            NSDictionary *dic = @{
                                  @"app_key":url,
                                  @"user_name":userName,
                                  @"user_pass":passWord,
                                  @"reg_type":@"0",
                                  @"th_id":@"0",
                                  @"baidu_id":baidu_id
                                  };
            [Base64Tool postSomethingToServe:url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
                NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
                if ([code isEqualToString:@"200"]) {
                    [SVProgressHUD dismiss];
                    NSDictionary *userDic = [param objectForKey:@"obj"];
                    [self loginSuccess:userDic];
                }else{
                    [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
                }
            } andErrorBlock:^(NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }];
        }
    }
}

#pragma mark-------登录成功之后的各种操作
-(void)loginSuccess :(NSDictionary*)userDic
{
    //记录用户信息
    [UserModel shareInstance].u_id = [userDic objectForKey:@"u_id"];
    [UserModel shareInstance].session_key = [userDic objectForKey:@"session_key"];
    [UserModel shareInstance].user_name = [userDic objectForKey:@"user_name"];
    [UserModel shareInstance].sex = [userDic objectForKey:@"sex"];
    [UserModel shareInstance].user_tel = [userDic objectForKey:@"user_tel"];
    [UserModel shareInstance].user_address = [userDic objectForKey:@"user_address"];
    [UserModel shareInstance].id_card = [userDic objectForKey:@"id_card"];
    [UserModel shareInstance].user_pic = [userDic objectForKey:@"user_pic"];
    [UserModel shareInstance].user_nickname = [userDic objectForKey:@"user_nickname"];
    [UserModel shareInstance].pay_point = [userDic objectForKey:@"pay_point"];
    //登录状态
    ApplicationDelegate.islogin = YES;
    //记录手机号，密码
    NSString *userName = userDefault(@"USERNAME");
    NSString *passWord = userDefault(@"PASSWORD");
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AUTULOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //跳转个人信息界面
    NSLog(@"登录成功了，该去做点别的了");
    NSString *baidu_id = userDefault(@"baidu_id");
    baidu_id = [NSString stringWithFormat:@"%@%@",baidu_id,[UserModel shareInstance].u_id];
    [self setAlian:baidu_id];
    [self checkStatus];
}

//检查是否私信
#pragma mark-------check status
-(void)checkStatus
{
    NSString *connect_url = @"user/ac_user/message_status";
    NSDictionary *dict = @{
                           @"app_key":connect_url,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [Base64Tool postSomethingToServe:connect_url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            if ([[param[@"obj"] objectForKey:@"index_message"] integerValue]==0) {
                [[HomeNavigationView shareInstance]addHint];
            }
            if ([[param[@"obj"] objectForKey:@"com_num"] integerValue]>0) {
                NSString *count = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"com_num"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ISNEWREPLY" object:count];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_CIRCLE_NEW_MESSAGE" object:count];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-------设置主页
-(void)setIndex
{
    /**
     暂时由于显示问题  不要设置动画显示
     */
    //    [UIView beginAnimations:nil context:nil];
    //    //设定动画持续时间
    //    [UIView setAnimationDuration:0.5];
    //    //动画的内容
    //    [_image setFrame:CGRectMake(320, 0, _image.frame.size.width, _image.frame.size.height)];
    //    [_image setAlpha:0];
    //    //动画结束
    //    [UIView commitAnimations];
    //    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(removeUserSelectView) userInfo:nil repeats:NO];
    [self removeUserSelectView];
}

-(void)removeUserSelectView
{
    //----读取json文件---在这里测试---不一定就放在这里了-----
    //[[JsonModel shareInstance] readJsonFromTxt:@"JsonFiel"];
    [_image removeFromSuperview];
    TabBarViewController *firVc = [[TabBarViewController alloc] init];
    self.window.rootViewController = firVc;
    //    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:firVc];
    self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
}

#pragma mark-------检测更新
-(void)checkVersion
{
    NSString *cr_version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *net_version = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_v"] ;
    if ([net_version compare:cr_version]==1) {
        NSString *is_update = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"is_update"] ;
        NSString *hintStr = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_desc"] ;
        if ([is_update intValue] == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"强制版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本更新" message:hintStr delegate:self cancelButtonTitle:@"去更新" otherButtonTitles:@"暂时不要了", nil];
            alert.tag = 1;
            [alert show];
        }
    }
}

#pragma mark-------alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            NSString *downLoadUrl = [[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"ios_download"] ;
            //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downLoadUrl]];
            AppUpdatesController * appUpdates = [[AppUpdatesController alloc] init];
            appUpdates.webURL = downLoadUrl;
            [appUpdates setNavBarTitle:@"更新APP" withFont:15.0f];
            [self.window.rootViewController.navigationController pushViewController:appUpdates animated:NO];
        }
    }else if(alertView.tag == 3){
        if (buttonIndex == 0) {
            NSInteger my_type = [self.type integerValue];
            TabBarViewController *firVC  = (TabBarViewController*)self.window.rootViewController;
            NSInteger index = firVC.selectedIndex;
            BaseViewController *indexViewController = [firVC.viewControllers objectAtIndex:index];
            UIViewController *currentViewCtrl = ((UINavigationController*)indexViewController).topViewController;
            if (my_type == 1) {//公告
                if (![indexViewController isKindOfClass:[ActivityDetailViewController class]]) {
                    ActivityDetailViewController *message = [[ActivityDetailViewController alloc] init];
                    message.url = self.url;
                    [firVC setTabBarHidden:YES animated:YES];
                    [message setNavBarTitle:@"公告详情" withFont:14.0f];
                    //                    [message.navigationItem setTitle:@"公告详情"];
                    [currentViewCtrl.navigationController pushViewController:message animated:YES];
                }
            }
        }
    }
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *sys_type = [[UIDevice currentDevice] systemName];
    NSString *sys_version = [[UIDevice currentDevice] systemVersion];
    NSString *model = [[UIDevice currentDevice] model]  ;
    NSString *str = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@\n the systemName is %@ \n the systemVersion is %@ \n the model is %@",name,reason,arr,sys_type,sys_version,model];
    NSLog(@"%@",str);
    //    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"crush_reason"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //[NSThread sleepForTimeInterval:3];
}

-(void)sendCrushMessage
{
    NSString *message = userDefault(@"crush_reason");
    if (message && message.length>0) {
        
        NSString *url = @"error/error_message";
        NSDictionary *dict = @{
                               @"error":message
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSLog(@"返回");
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"crush_reason"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self setAlian:@"0"];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}


@end
