//
//  orderRoomDetailViewController.m
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  订酒店

#import "orderRoomDetailViewController.h"
#import "orderRoomDetailInfo.h"
#import "orderRoomDetailTableViewCell.h"
#import "ReviewListViewController.h"
#import "orderRoomSubmitViewController.h"
#import "roomInfo.h"
#import "UMSocial.h"
#import "MapViewController.h"

@interface orderRoomDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UMSocialUIDelegate>
{
    orderRoomDetailInfo *detailInfo;
}
@property (strong,nonatomic)UIButton *shareButton;
@property (strong,nonatomic)UITableView *orderRoomDetailTableview;
@end

@implementation orderRoomDetailViewController

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

#pragma mark-------get Data
-(void)getDataFromNet
{
    NSString *url = connect_url(@"hotel_shop_message");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"shop_id":self.shop_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [SVProgressHUD dismiss];
            detailInfo = [[orderRoomDetailInfo alloc] initWithDictionary:param[@"obj"]];
            [self.orderRoomDetailTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}
#pragma mark-------set UI
-(void)setUI
{
    [self.view addSubview:self.orderRoomDetailTableview];
    [_orderRoomDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_orderRoomDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_orderRoomDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-2.0f];
    [_orderRoomDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
    UIBarButtonItem *shareBar = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem = shareBar;
}
#pragma mark-------get UI
-(UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareButton.imageEdgeInsets =  UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _shareButton;
}

-(UITableView *)orderRoomDetailTableview
{
    if (!_orderRoomDetailTableview) {
        _orderRoomDetailTableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _orderRoomDetailTableview.translatesAutoresizingMaskIntoConstraints=NO;
        _orderRoomDetailTableview.delegate = self;
        _orderRoomDetailTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_orderRoomDetailTableview];
        if ([_orderRoomDetailTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_orderRoomDetailTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_orderRoomDetailTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_orderRoomDetailTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _orderRoomDetailTableview;
}
#pragma mark-------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 1) {
            NSLog(@"跳转到评价列表");
            ReviewListViewController *firVC = [[ReviewListViewController alloc] init];
            firVC.shop_id = detailInfo.shop_id;
            firVC.index = @"3";
            [firVC setNavBarTitle:@"评价" withFont:14.0f];
//            [firVC.navigationItem setTitle:@"评价"];
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }else if (section == 1){
        if(row == 0){
            NSLog(@"拨打电话");
            NSLog(@"拨打电话");
            NSString *telePhone = detailInfo.shop_tel;
            NSArray *array = [telePhone componentsSeparatedByString:@","];
            if ([array count]==1) {
                NSString *num = [array objectAtIndex:0];
                [UZCommonMethod callPhone:num superView:self.view];
            }else{
                NSString *tel_one = [array objectAtIndex:0];
                NSString *tel_two = [array objectAtIndex:1];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系商家" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:tel_one,tel_two,nil];
                alert.tag = 2;
                [alert show];
            }
        }
        if (row == 1) {
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
                //                firVC.myLat = self.my_lat;
                //                firVC.myLnt = self.my_lng;
                [self.navigationController pushViewController:firVC animated:YES];
            }
        }
    }else{
        if (indexPath.row != 0) {
            roomInfo *goods_info = [detailInfo.goods_list objectAtIndex:row-1];
            orderRoomSubmitViewController *firVC = [[orderRoomSubmitViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"提交订单" withFont:14.0f];
            //        [firVC.navigationItem setTitle:@"提交订单"];
            firVC.info = detailInfo;
            firVC.goods_info = goods_info;
            [self.navigationController pushViewController:firVC animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    CGFloat height = 0.0;
    switch (section) {
        case 0:
            if (row==0) {
                height = 180;
            }else{
                height = 40;
            }
            break;
        case 1:
            height = 40;
            break;
        case 2:
            if (row == 0) {
                height = 40;
            }else{
                height = 60;
            }
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_room_detail_cell";
    orderRoomDetailTableViewCell *cell=(orderRoomDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[orderRoomDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (detailInfo == nil) {
        [cell confirgureDetailCell:self.info section:section row:row];
    }else{
        [cell confirgureCell:detailInfo section:section row:row];
    }
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 2;
    if (section == 2 && detailInfo != nil) {
        count = [detailInfo.goods_list count]+1;
    }
    
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (detailInfo == nil && self.info != nil) {
        return 2;
    }
    if (detailInfo == nil && self.info == nil) {
        return 0;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

#pragma mark-------share action
-(void)shareAction:(UIButton*)sender
{
    [self UserSharePoint];
    //NSString *url = @"www.baidu.com";
    NSString *sinaText = [NSString stringWithFormat:@"如e生活 %@",detailInfo.share_url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = detailInfo.shop_name;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = detailInfo.shop_name;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = detailInfo.share_url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = detailInfo.shop_name;
    [UMSocialData defaultData].extConfig.qzoneData.url = detailInfo.share_url;
    
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

#pragma mark-------others
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *telePhone = detailInfo.shop_tel;
    NSArray *array = [telePhone componentsSeparatedByString:@","];
    if (alertView.tag == 2) {
        NSString *tel_one = [array objectAtIndex:0];
        NSString *tel_two = [array objectAtIndex:1];
        if (buttonIndex == 1) {
            [UZCommonMethod callPhone:tel_one superView:self.view];
        }else if (buttonIndex == 2){
            [UZCommonMethod callPhone:tel_two superView:self.view];
        }
    }
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
