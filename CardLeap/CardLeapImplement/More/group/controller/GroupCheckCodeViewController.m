//
//  GroupCheckCodeViewController.m
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "GroupCheckCodeViewController.h"
#import "GroupCheckCodeTableViewCell.h"
#import "GroupDetailViewController.h"
#import "myGroupDetailViewController.h"
#import "UMSocial.h"

@interface GroupCheckCodeViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property (strong,nonatomic)UITableView *groupCheckTableview;
@property (strong,nonatomic)UIButton *shareButton;
@property (strong,nonatomic)UIButton *backButton;
@end

@implementation GroupCheckCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

#pragma mark-----set UI
-(void)setUI
{
    if (![self.identifier isEqualToString:@"1"]) {
        //set back button
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
        self.navigationItem.leftBarButtonItem = leftBar;
    }
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self.view addSubview:self.groupCheckTableview];
    [_groupCheckTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_groupCheckTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_groupCheckTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_groupCheckTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
}

#pragma mark-----get UI
-(UITableView *)groupCheckTableview
{
    if (!_groupCheckTableview) {
        _groupCheckTableview = [[UITableView alloc] initForAutoLayout];
        //_groupCheckTableview.translatesAutoresizingMaskIntoConstraints = NO;
        _groupCheckTableview.delegate = self;
        _groupCheckTableview.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_groupCheckTableview];
        if ([_groupCheckTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_groupCheckTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([_groupCheckTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_groupCheckTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _groupCheckTableview;
}

-(UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [_shareButton setImage:[UIImage imageNamed:@"navtakeout_send_no"] forState:UIControlStateNormal];
        [_shareButton setImage:[UIImage imageNamed:@"navtakeout_send_sel"] forState:UIControlStateHighlighted];
        [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

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

#pragma mark-----tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    if (indexPath.section == 0 && indexPath.row == 0) {
        GroupDetailViewController *firVC = [[GroupDetailViewController alloc] init];
        [firVC setNavBarTitle:@"如e商家" withFont:14.0f];
        firVC.group_id = [self.messageDict objectForKey:@"group_id"];
        [self.navigationController pushViewController:firVC animated:YES];
        //        myGroupDetailViewController *firVC = [[myGroupDetailViewController alloc] init];
        //        [firVC setHiddenTabbar:YES];
        //        [firVC setNavBarTitle:@"订单详情" withFont:14.0f];
        //        //        [firVC.navigationItem setTitle:@"订单详情"];
        //        [self.navigationController pushViewController:firVC animated:YES];
    }
    
    
    //    MySpikeListViewController *firVC = [[MySpikeListViewController alloc] init];
    //    [firVC setHiddenTabbar:YES];
    //    [firVC.navigationItem setTitle:@"我的优惠券"];
    //    [self.navigationController pushViewController:firVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }else{
        return 5.0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count = 1;
    if (section == 0) {
        count = 1;
    }else{
        count = (int)[self.passArray count];
    }
    return count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 200;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_message_cell";
    GroupCheckCodeTableViewCell *cell=(GroupCheckCodeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[GroupCheckCodeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    NSDictionary *dic = @{
                          @"spike_code":self.passArray,
                          @"spike_desc":[self.messageDict objectForKey:@"group_name"],
                          @"spike_end_time":[self.messageDict objectForKey:@"group_endtime"]
                          };
    [cell confirgureCell:dic section:indexPath.section row:indexPath.row];
    //cell.showsReorderControl = YES;
    return cell;
}


#pragma mark-----button action
-(void)shareAction:(UIButton*)sender
{
    NSLog(@"分享出去");
    [self UserSharePoint];
    NSString *share_text = [NSString stringWithFormat:@"我在如e生活为你团购了%@",[self.messageDict objectForKey:@"group_name"]];
    NSString *spike_code ;
    for (int i = 0; i<[self.passArray count]; i++) {
        spike_code = [NSString stringWithFormat:@"%@ %@",spike_code,[[self.passArray objectAtIndex:i] objectForKey:@"order_pass"]];
    }
    share_text = [NSString stringWithFormat:@"%@密码是：%@",share_text,spike_code];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:nil
                                      shareText:share_text
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToSms]
                                       delegate:self];
    
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

-(void)backAction:(UIButton*)sender
{
    NSLog(@"判断如何返回");
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
