//
//  myRoomSuccessViewController.m
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "myRoomSuccessViewController.h"
#import "orderRoomDetailViewController.h"
#import "UMSocial.h"
#import "orderRoomSuccessInfo.h"
#import "orderRoomSuccessTableViewCell.h"
#import "orderRoomDetailViewController.h"

@interface myRoomSuccessViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
{
    NSDictionary *orderMessageDic;
    orderRoomSuccessInfo *messageInfo;
}
@property (strong,nonatomic)UITableView *mySeatTableview;
@property (strong,nonatomic)UIButton *backToShopButton;
@property (strong,nonatomic)UIButton *shareToFriendButton;
@end

@implementation myRoomSuccessViewController

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

#pragma mark-----get Data From
-(void)getDataFromNet
{
    NSString *url = connect_url(@"hotel_order_status");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"hotel_id":self.room_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue] == 200) {
            [SVProgressHUD dismiss];
            messageInfo = [[orderRoomSuccessInfo alloc] initWithDictionary:param[@"obj"]];
            [self.mySeatTableview reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
}

#pragma mark-----set UI
-(void)setUI
{
    [self.view addSubview:self.mySeatTableview];
    [_mySeatTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_mySeatTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_mySeatTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_mySeatTableview autoSetDimension:ALDimensionHeight toSize:120.0f];
    
    [self.view addSubview:self.backToShopButton];
    [_backToShopButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_backToShopButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mySeatTableview withOffset:20.0f];
    [_backToShopButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_backToShopButton autoSetDimension:ALDimensionWidth toSize:130.0f*LinPercent];
    
    [self.view addSubview:self.shareToFriendButton];
    [_shareToFriendButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_shareToFriendButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mySeatTableview withOffset:20.0f];
    [_shareToFriendButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_shareToFriendButton autoSetDimension:ALDimensionWidth toSize:130.0f*LinPercent];
}

#pragma mark-----get UI
-(UITableView *)mySeatTableview
{
    if (!_mySeatTableview) {
        _mySeatTableview = [[UITableView alloc] initForAutoLayout];
        _mySeatTableview.delegate = self;
        _mySeatTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_mySeatTableview];
        _mySeatTableview.separatorInset = UIEdgeInsetsZero;
    }
    return _mySeatTableview;
}

-(UIButton *)shareToFriendButton
{
    if (!_shareToFriendButton) {
        _shareToFriendButton = [[UIButton alloc] initForAutoLayout];
        _shareToFriendButton.layer.masksToBounds = YES;
        _shareToFriendButton.layer.cornerRadius = 4.0f;
        [_shareToFriendButton setBackgroundColor:UIColorFromRGB(0x79c4d2)];
        _shareToFriendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_shareToFriendButton setTitle:@"分享好友" forState:UIControlStateNormal];
        [_shareToFriendButton setTitle:@"分享好友" forState:UIControlStateHighlighted];
        [_shareToFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareToFriendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_shareToFriendButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareToFriendButton;
}

-(UIButton *)backToShopButton
{
    if (!_backToShopButton) {
        _backToShopButton = [[UIButton alloc] initForAutoLayout];
        _backToShopButton.layer.masksToBounds = YES;
        _backToShopButton.layer.cornerRadius = 4.0f;
        [_backToShopButton setBackgroundColor:UIColorFromRGB(0xe44e55)];
        _backToShopButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        if ([self.identifier isEqualToString:@"1"]) {
            [_backToShopButton setTitle:@"返回" forState:UIControlStateNormal];
            [_backToShopButton setTitle:@"返回" forState:UIControlStateHighlighted];
        }else{
            [_backToShopButton setTitle:@"返回商家" forState:UIControlStateNormal];
            [_backToShopButton setTitle:@"返回商家" forState:UIControlStateHighlighted];
        }
        [_backToShopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backToShopButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_backToShopButton addTarget:self action:@selector(backToShopAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backToShopButton;
}

#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    if (indexPath.row == 0) {
        orderRoomDetailViewController *firVC = [[orderRoomDetailViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:messageInfo.shop_name withFont:14.0f];
//        [firVC.navigationItem setTitle:messageInfo.shop_name];
        firVC.shop_id = messageInfo.shop_id;
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"order_room_success_cell";
    orderRoomSuccessTableViewCell *cell=(orderRoomSuccessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[orderRoomSuccessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    [cell confirgureCell:messageInfo row:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (messageInfo==nil) {
        return 0;
    }
    return 3;
}


#pragma mark-----button action
-(void)backToShopAction:(UIButton*)sender
{
    if ([self.identifier isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"返回到商家");
        NSArray *subViews = self.navigationController.viewControllers;
        for (BaseViewController *obj in subViews) {
            if ([obj isKindOfClass:[orderRoomDetailViewController class]]) {
                [self.navigationController popToViewController:obj animated:YES];
                break;
            }
        }
    }
}

-(void)shareAction:(UIButton*)sender
{
    [self UserSharePoint];
    /**
     我在XXX酒店（酒店名）为你预定了xx（房间类型）客房。时间是xx月xx日至xx月xx日（预定时间）。联系人：xxx 电话：xxxxxxxxxxxxxx请记得到店确认。
     */
    NSString *share_text = [NSString stringWithFormat:@"我在%@酒店为你预定了%@间客房。时间是%@至%@。联系人:%@ 电话：%@,请记得到店确认",messageInfo.shop_name,messageInfo.hotel_num,messageInfo.begin_time,messageInfo.end_time,messageInfo.use_name,messageInfo.hotel_tel];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:share_text
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToSms,UMShareToWechatSession]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = share_text;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = messageInfo.share_url;

    [UMSocialData defaultData].extConfig.smsData.shareText = share_text;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
