//
//  ShopTakeOutDetailViewController.m
//  CardLeap
//
//  Created by lin on 12/30/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖

#import "ShopTakeOutDetailViewController.h"
#import "shopTakeDetailTableViewCell.h"
#import "UMSocial.h"
#import "ReviewListViewController.h"

@interface ShopTakeOutDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (strong, nonatomic) UITableView *shopDetailTableview;
@property (strong, nonatomic) UIButton *rightButton;
@end

@implementation ShopTakeOutDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------------set UI
-(void)setUI
{
    [self.view addSubview:self.shopDetailTableview];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_shopDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-2.0f];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

#pragma mark---------------get UI
-(UITableView *)shopDetailTableview
{
    if (!_shopDetailTableview) {
        _shopDetailTableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _shopDetailTableview.translatesAutoresizingMaskIntoConstraints = NO;
        _shopDetailTableview.delegate = self;
        _shopDetailTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_shopDetailTableview];
        //[_shopDetailTableview setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _shopDetailTableview;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rightButton setImage:[UIImage imageNamed:@"coupon_share_no"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"coupon_share_sel"] forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    }
    return _rightButton;
}

#pragma mark-----share action
-(void)shareAction:(UIButton*)btn
{
    NSLog(@"分享什么东西");
    [self UserSharePoint];
    //NSString *url = @"www.baidu.com";
    NSString *sinaText = [NSString stringWithFormat:@"如e生活%@",self.info.share_url];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:@"如e生活"
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToSina,UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQzone]
                                       delegate:self];
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.info.share_url;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.info.share_url;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = @"如e生活";
    [UMSocialData defaultData].extConfig.qzoneData.url = self.info.share_url;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = sinaText;
//   [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.info.share_url;
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

#pragma mark-----table view delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击去查看评价
    if (indexPath.section == 2) {
        ReviewListViewController *firVC = [[ReviewListViewController alloc] init];
        firVC.shop_id = self.info.shop_id;
        firVC.index = @"2";
        [firVC setNavBarTitle:@"评价" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"评价"];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    CGFloat height;
    switch (section) {
        case 0:
            height = 100.0;
            break;
        case 1:
            height = 60.0;
            break;
        case 2:
            height = 45.0;
            break;
        case 3:
            if (indexPath.row == 0) {
                height = 40.0;
            }else{
                //通过计算得到
                int line = self.info.shop_take_desc.length / 21+1;
                int height_lable = line*15;
                if (height_lable>280) {
                    height = height_lable;
                    break;
                }
                height = 280;
            }
            break;
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"shop_detail_cell";
    shopTakeDetailTableViewCell *cell=(shopTakeDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[shopTakeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell confirgureCell:self.info sectino:indexPath.section row:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    switch (section) {
        case 0:
            count = 1;
            break;
        case 1:
            count = 1;
            break;
        case 2:
            count = 1;
            break;
        case 3:
            count = 2;
            break;
        default:
            break;
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

/*
#pragma mark - Navigation
//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
