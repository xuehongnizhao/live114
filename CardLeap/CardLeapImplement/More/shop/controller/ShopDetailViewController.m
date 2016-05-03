//
//  ShopDetailViewController.m
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  商家详情

#import "ShopDetailViewController.h"
#import "shopDetailInfo.h"
#import "ShopDetailTableViewCell.h"
#import "ShopDetailTableViewCell.h"
#import "LoginViewController.h"
#import "ShowAllImageViewController.h"
#import "ReviewListViewController.h"
#import "ShopTakeOutViewController.h"
#import "orderSeatDetailViewController.h"
#import "orderRoomDetailViewController.h"
#import "ShopGroupViewController.h"
#import "ShopSpikeViewController.h"
#import "ShopActivityViewController.h"
#import "UMSocial.h"
#import "MapViewController.h"
#import "ShopDetailWebViewController.h" // 商家详情web
#import "myOrderCenterInfo.h"
#import "RviewDishListViewController.h"
#import "ShopAdviertisementView.h"
#import "linNewFunctionWebController.h"
@interface ShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate,shopPicDelegate,UIAlertViewDelegate,UMSocialUIDelegate,UIActionSheetDelegate>
{
    shopDetailInfo *detailInfo;//商家详情实体类
    NSString *panorama;
    NSArray *adInfoList;//广告界面数据
    NSArray *SJHDP;//商家幻灯片
    NSArray *SJHD;//商家活动
    NSArray *SJSC;//商家商城
    NSArray *SJZS;//商家展示
    ShopAdviertisementView *adView;
}
@property (strong, nonatomic) UITableView *shopDetailTableview;//商家详情tableview
@property (strong, nonatomic) UIButton *collectButton;//收藏按钮
@property (strong, nonatomic) UIButton *shareButton;//分享按钮
@property (strong, nonatomic) ShopAdviertisementView *adView;//商家广告视图
@end

@implementation ShopDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self getDataFromNet];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setHiddenTabbar:YES];
}

#pragma mark----------set UI
-(void)setUI
{
    [self.view addSubview:self.shopDetailTableview];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-2.0f];
    //right button
    [self setButton];
    
    
}

#pragma mark----------set navigationItem bars
-(void)setButton
{
    if (detailInfo!=nil) {
        NSString *collect = detailInfo.collection;
        //UIButton *btn = self.collectButton;
        if ([collect isEqualToString:@"0"]) {
            [self.collectButton setImage:[UIImage imageNamed:@"shop_sc_no"] forState:UIControlStateNormal];
            [_collectButton setImage:[UIImage imageNamed:@"shop_sc_sel"] forState:UIControlStateHighlighted];
        }else{
            [self.collectButton setImage:[UIImage imageNamed:@"shop_sc_success_no"] forState:UIControlStateNormal];
            [_collectButton setImage:[UIImage imageNamed:@"shop_sc_success_sel"] forState:UIControlStateHighlighted];
        }
    }
    UIBarButtonItem *collectionBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.collectButton];
    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    NSArray *arr = @[shareBarItem,collectionBarItem];
    self.navigationItem.rightBarButtonItems = arr;
}

#pragma mark----------get data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"shop_message");
    NSString *uid = @"0";
    if (ApplicationDelegate.islogin == YES) {
        uid = [UserModel shareInstance].u_id;
    }
    NSDictionary *dic = @{
                          @"shop_id":self.shop_id,
                          @"app_key":url,
                          @"u_id":uid
                          };
    [Base64Tool postSomethingToServe:url andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",param);
            detailInfo = [[shopDetailInfo alloc] initWithDictionary:[param objectForKey:@"obj"]];
            [self.shopDetailTableview reloadData];
            [self setButton];
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    NSString *url1 = connect_url(@"business_extend");
    NSString *uid1 = @"0";
    if (ApplicationDelegate.islogin == YES) {
        uid1 = [UserModel shareInstance].u_id;
    }
    NSDictionary *dic1 = @{
                           @"shop_id":self.shop_id,
                           @"app_key":url1,
                           @"u_id":uid1
                           };
    [Base64Tool postSomethingToServe:url1 andParams:dic1 isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",param);
            panorama=[[param objectForKey:@"obj"]objectForKey:@"360QJ"];
            SJHDP=[[param objectForKey:@"obj"]objectForKey:@"SJHDP"];
            SJSC=[[param objectForKey:@"obj"]objectForKey:@"SJSC"];
            SJHD=[[param objectForKey:@"obj"]objectForKey:@"SJHD"];
            SJZS=[[param objectForKey:@"obj"]objectForKey:@"SJZS"];
            adInfoList=@[SJHDP,SJSC,SJHD,SJZS];
            [self.shopDetailTableview reloadData];
            NSLog(@"%@",adInfoList);
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    
}


#pragma mark----------get UI
- (ShopAdviertisementView *)adView{
    if (!_adView) {
        _adView=[[[NSBundle mainBundle]loadNibNamed:@"ShopAdviertisementView" owner:self options:nil]lastObject];
        
    }
    return _adView;
}

-(UITableView *)shopDetailTableview
{
    if (!_shopDetailTableview) {
        _shopDetailTableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _shopDetailTableview.translatesAutoresizingMaskIntoConstraints = NO;
        _shopDetailTableview.delegate = self;
        _shopDetailTableview.dataSource =self;
        [UZCommonMethod hiddleExtendCellFromTableview:_shopDetailTableview];
        if ([_shopDetailTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_shopDetailTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_shopDetailTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_shopDetailTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _shopDetailTableview;
}
//---分享按钮---------
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
//---收藏按钮-----------
-(UIButton *)collectButton
{
    if (!_collectButton) {
        _collectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_collectButton addTarget:self action:@selector(collectAciont:) forControlEvents:UIControlEventTouchUpInside];
        _collectButton.imageEdgeInsets =  UIEdgeInsetsMake(0, 20, 0, -20);
        if (self.info!= nil&&detailInfo == nil) {
            NSString *collect = self.info.collect;
            if ([collect isEqualToString:@"0"]) {
                [_collectButton setImage:[UIImage imageNamed:@"shop_sc_no"] forState:UIControlStateNormal];
                [_collectButton setImage:[UIImage imageNamed:@"shop_sc_sel"] forState:UIControlStateHighlighted];
            }else{
                [_collectButton setImage:[UIImage imageNamed:@"shop_sc_success_no"] forState:UIControlStateNormal];
                [_collectButton setImage:[UIImage imageNamed:@"shop_sc_success_sel"] forState:UIControlStateHighlighted];
            }
        }else{
            if (self.info==nil && detailInfo != nil) {
                NSString *collect = detailInfo.collection;
                if ([collect isEqualToString:@"0"]) {
                    [_collectButton setImage:[UIImage imageNamed:@"shop_sc_no"] forState:UIControlStateNormal];
                    [_collectButton setImage:[UIImage imageNamed:@"shop_sc_sel"] forState:UIControlStateHighlighted];
                }else{
                    [_collectButton setImage:[UIImage imageNamed:@"shop_sc_success_no"] forState:UIControlStateNormal];
                    [_collectButton setImage:[UIImage imageNamed:@"shop_sc_success_sel"] forState:UIControlStateHighlighted];
                }
            }
        }
    }
    return _collectButton;
}

#pragma mark-----------button actino
-(void)shareActino :(UIButton*)sender
{
    NSLog(@"点击分享");
    [self UserSharePoint];
    NSString *sinaText = [NSString stringWithFormat:@"如e生活%@",detailInfo.share_url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.qzoneData.url = detailInfo.share_url;
    
    //NSString *sinaText = [NSString stringWithFormat:@"城市o2o%@",detailInfo.share_url];
    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaText;
    //[UMSocialData defaultData].extConfig.sinaData.urlResource.url = detailInfo.share_url;
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

//收藏方法
-(void)collectAciont :(UIButton*)sender
{
    NSLog(@"点击收藏----登录才能收藏");
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        firVC.identifier = @"0";
        firVC.navigationItem.title = @"登录";
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        NSString *collect ;
        if (detailInfo != nil) {
            collect = detailInfo.collection;
        }
        NSString *url = connect_url(@"shop_collection");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"shop_id":self.shop_id,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"session_key":[UserModel shareInstance].session_key,
                               @"collection":collect
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [SVProgressHUD showSuccessWithStatus:[param objectForKey:@"message"]];
                if ([collect isEqualToString:@"0"]) {
                    //判断取消收藏 还是 收藏成功
                    detailInfo.collection = @"1";
                    [sender setImage:[UIImage imageNamed:@"shop_sc_success_no"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"shop_sc_success_sel"] forState:UIControlStateHighlighted];
                }else{
                    detailInfo.collection = @"0";
                    //判断取消收藏 还是 收藏成功
                    [sender setImage:[UIImage imageNamed:@"shop_sc_no"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"shop_sc_sel"] forState:UIControlStateHighlighted];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}
//-----------alert delegate-----------
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *telePhone = detailInfo.shop_tel;
    NSArray *array = [telePhone componentsSeparatedByString:@","];
    if (alertView.tag == 1) {
        NSString *tel_one = [array objectAtIndex:0];
        if (buttonIndex == 0) {
            [UZCommonMethod callPhone:tel_one superView:self.view];
        }
    }else if (alertView.tag == 2){
        NSString *tel_one = [array objectAtIndex:0];
        NSString *tel_two = [array objectAtIndex:1];
        if (buttonIndex == 2) {
            [UZCommonMethod callPhone:tel_two superView:self.view];
        }else if (buttonIndex == 1){
            [UZCommonMethod callPhone:tel_one superView:self.view];
        }
    }
}


#pragma mark-----------tableview delegate
#pragma mark --- 2016.4 商家界面点击各种跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击各种乱跳转");
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *arr = [detailInfo.shop_action componentsSeparatedByString:@","];
    arr = [self clearArray:arr];
    NSString *tmpAction ;
    if (section == 2) {
        tmpAction = [arr objectAtIndex:row];
    }
    switch (section) {
        case 0:
            
            break;
        case 1:
            if (row == 0) {
                NSLog(@"拨打电话");
                NSString *telePhone = detailInfo.shop_tel;
                NSArray *array = [telePhone componentsSeparatedByString:@","];
                if ([array count]==1) {
                    [UZCommonMethod callPhone:array[0] superView:self.view];
                }else{
                    NSString *tel_one = [array objectAtIndex:0];
                    NSString *tel_two = [array objectAtIndex:1];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系商家" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:tel_two, tel_one,nil];
                    alert.tag = 2;
                    [alert show];
                }
            }else if(row == 1){
                // 商家地址
                if (detailInfo != nil || self.info!= nil) {
                    MapViewController *firVC = [[MapViewController alloc] init];
                    if (self.info!= nil ) {
                        firVC.addr =self.info.shop_name;
                        firVC.latitude = self.info.shop_lat;
                        firVC.longitude = self.info.shop_lng;
                    }else{
                        firVC.addr = detailInfo.shop_name;
                        firVC.latitude = detailInfo.shop_lat;
                        firVC.longitude = detailInfo.shop_lng;
                    }
                    firVC.myLat = self.my_lat;
                    firVC.myLnt = self.my_lng;
                    [self.navigationController pushViewController:firVC animated:YES];
                }else{
                }
            }else if(row==2){
                // 商家详情
                NSLog(@"跳转到商家详情");
                if (self.info.message_url != nil) {
                    ShopDetailWebViewController *firVC = [[ShopDetailWebViewController alloc] init];
                    firVC.shopDetailWebURL = self.info.message_url;
                    [firVC setNavBarTitle:@"详情" withFont:14.0f];
                    [self.navigationController pushViewController:firVC animated:YES];
                }else if (self.message_url != nil){
                    ShopDetailWebViewController *firVC = [[ShopDetailWebViewController alloc] init];
                    firVC.shopDetailWebURL = self.message_url;
                    [firVC setNavBarTitle:@"详情" withFont:14.0f];
                    [self.navigationController pushViewController:firVC animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"此商家暂无详情"];
                }
                
            }else if(row ==3){
#pragma mark --- 跳转360全景视图
                linNewFunctionWebController *panoramaVC=[[linNewFunctionWebController alloc]init];
                panoramaVC.title=@"360全景视图";
                panoramaVC.url=panorama;
                [self.navigationController pushViewController:panoramaVC animated:YES];
            }else{
                NSLog(@"跳转到评价列表");
                ReviewListViewController *firVC = [[ReviewListViewController alloc] init];
                firVC.shop_id = detailInfo.shop_id;
                [firVC setNavBarTitle:@"评价" withFont:14.0f];
                firVC.index = @"0";
                [self.navigationController pushViewController:firVC animated:YES];
            }
            break;
        case 2:
            [self go2shopActon:tmpAction];
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==2&&(SJHDP.count!=0||SJZS.count!=0||SJSC.count!=0||SJHD.count!=0)) {
        
        return adView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    adView=[[ShopAdviertisementView alloc]init];
    adView.SJHDP=SJHDP;
    adView.SJZS=SJZS;
    adView.SJHD=SJHD;
    adView.SJSC=SJSC;
    adView.shop_name=detailInfo.shop_name;
    adView.backgroundColor=[UIColor whiteColor];
    CGFloat height=5;
    if (section==2) {
        if (SJHDP.count!=0) {
            height+=SCREEN_WIDTH/3;
        }
        if (SJZS.count!=0) {
            height+=0.3*SCREEN_WIDTH*SJZS.count/2+40;
        }
        if (SJHD.count!=0) {
            height+=0.3*SCREEN_WIDTH*SJHD.count/2+40;
        }
        if (SJSC.count!=0) {
            height+=0.3*SCREEN_WIDTH*SJSC.count+40;
        }
        return height;
    }
    return 5.0f;
    
}
/**
 调用actiondelegate
 选择之后调用到高德或者百度地图
 */
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self goOtherMap:@"使用高德地图导航"];
    }else if(buttonIndex == 1){
        [self goOtherMap:@"使用百度地图导航"];
    }
}

#pragma mark-------判断跳转到各个页面
-(void)go2shopActon:(NSString*)action
{
    if ([action isEqualToString:@"group"]) {
        //msgText = @"查看团购";
        if ([detailInfo.group_num integerValue]>0) {
            ShopGroupViewController *firVC = [[ShopGroupViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            firVC.shop_id = detailInfo.shop_id;
            [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }else if ([action isEqualToString:@"seat"]){
        //msgText = @"预定座位";
        orderSeatDetailViewController *firVC = [[orderSeatDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        firVC.shop_id = detailInfo.shop_id;
        [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([action isEqualToString:@"hotel"]){
        //msgText = @"预定酒店";
        orderRoomDetailViewController *firVC = [[orderRoomDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
        firVC.shop_id = detailInfo.shop_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([action isEqualToString:@"takeout"]){
        //msgText = @"外  卖";
        //        if ([detailInfo.takeout_num integerValue]>0) {
        ShopTakeOutViewController *firVC = [[ShopTakeOutViewController alloc] init];
        [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
        firVC.shop_id = self.shop_id;
        [self.navigationController pushViewController:firVC animated:YES];
        //        }
    }else if ([action isEqualToString:@"spike"]){
        //msgText = @"优惠券";
        if ([detailInfo.spike_num integerValue]>0) {
            ShopSpikeViewController *firVC = [[ShopSpikeViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
            firVC.shop_id = detailInfo.shop_id;
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }else if ([action isEqualToString:@"activity"]){
        //msgText = @"活  动";
        if ([detailInfo.event_num integerValue]>0) {
            ShopActivityViewController *firVC = [[ShopActivityViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:detailInfo.shop_name withFont:14.0f];
            firVC.shop_id = detailInfo.shop_id;
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger colum = indexPath.row;
    CGFloat height ;
    switch (section) {
        case 0:
            height = 93.0f;
            break;
        case 1:
            height = 45.0f;
            break;
        case 2:
            height = 45.0f;
            break;
        case 3:
            if (colum == 0) {
                height = 31.0f;
            }else if(colum == 6){
                height = 40.0f;
            }
            else{
                //通过计算
                height = 70.0f;
            }
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"index_cell";
    ShopDetailTableViewCell *cell=(ShopDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[ShopDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }else{
        while ([cell.contentView.subviews lastObject]!=nil) {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    cell.delegate =self;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (detailInfo != nil) {
        [cell configureCell:row sectino:section info:detailInfo];
    }else{
        [cell configureCellForMin:row sectino:section info:self.info];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark----------------点击图片进入相册
-(void)clickAction
{
    NSLog(@"跳相册了");
    ShowAllImageViewController *firVC = [[ShowAllImageViewController alloc] init];
    firVC.iamgeArray = detailInfo.shop_pic_list;
    [firVC setNavBarTitle:@"商家相册" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"商家相册"];
    [self.navigationController pushViewController:firVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger height = 0;
    NSArray *shopActionarray = [detailInfo.shop_action componentsSeparatedByString:@","];
    switch (section) {
        case 0:
            height = 1;
            break;
        case 1:
            height = 5;
            break;
        case 2:
            if (detailInfo == nil) {
                shopActionarray = [self.info.shop_action componentsSeparatedByString:@","];
                shopActionarray = [self clearArray:shopActionarray];
                height = [shopActionarray count];
            }else{
                shopActionarray = [self clearArray:shopActionarray];
                height = [shopActionarray count];
            }
            break;
            //        case 3:
            //            if (detailInfo != nil) {
            //                NSInteger count = [detailInfo.review_index count];
            //                if (count==5) {
            //                    height = 7;
            //                }else{
            //                    height = count+1;
            //                }
            //            }else{
            //                height = 0;
            //            }
            //            break;
        default:
            break;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //商家列表获取数据
    if (self.info!=nil && detailInfo == nil) {
        return 2;
    }
    //只传入了shop_id  然后访问接口获取数据的情况
    if (self.info == nil && detailInfo == nil) {
        return 0;
    }
    //    if (self.info!=nil&&detailInfo==nil&&adInfo!=nil) {
    //        return 4;
    //    }
    
    return 3;
}


-(void)goOtherMap:(NSString*)title
{
    BOOL hasBaiduMap = NO;
    BOOL hasGaodeMap = NO;
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        hasBaiduMap = YES;
    }else{
        
    }
    
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
        hasGaodeMap = YES;
    }else{
        
    }
    
    CGFloat tmp_lat = [self.my_lat floatValue];
    CGFloat tmp_lng = [self.my_lng floatValue];
    CGFloat shop_lat = [self.info.shop_lat floatValue];
    CGFloat shop_lnt = [self.info.shop_lng floatValue];
    if ([@"使用百度地图导航" isEqualToString:title])
    {
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving",tmp_lat, tmp_lng ,shop_lat,shop_lnt] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        if (hasBaiduMap == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装高德地图客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if ([@"使用高德地图导航" isEqualToString:title])
    {
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&poiname=%@&lat=%f&lon=%f&dev=1&style=2",@"app name",
                                @"IOSCity", @"终点", shop_lat, shop_lnt] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        if (hasGaodeMap == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装百度地图客户端" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

/**
 *  判断数组内是否含有vip rz字样 不做显示
 */
-(NSArray*)clearArray:(NSArray*)tmpArray
{
    NSMutableArray *myArray=[[NSMutableArray alloc] init];
    for (NSString *title in tmpArray) {
        if (![title isEqualToString:@"vip"] && ![title isEqualToString:@"rz"]) {
            [myArray addObject:title];
        }
    }
    NSArray *resultArray = [myArray copy];
    return resultArray;
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
