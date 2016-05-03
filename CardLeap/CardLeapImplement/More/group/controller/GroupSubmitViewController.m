//
//  GroupSubmitViewController.m
//  CardLeap
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "GroupSubmitViewController.h"
#import "groupSubmitTableViewCell.h"
#import "GroupPayViewController.h"
#import "LoginViewController.h"

@interface GroupSubmitViewController ()<UITableViewDataSource,UITableViewDelegate,groupButtonDelegate>
{
    NSInteger count;
}
@property (strong,nonatomic)UITableView *groupSubmitTableview;
@property (strong,nonatomic)UIButton *groupSubmitButton;
@end

@implementation GroupSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark------initData
-(void)initData
{
    count=1;
}

#pragma mark------set UI
-(void)setUI
{
    [self.view addSubview:self.groupSubmitTableview];
    [_groupSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_groupSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_groupSubmitTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_groupSubmitTableview autoSetDimension:ALDimensionHeight toSize:120.0f];
    
    [self.view addSubview:self.groupSubmitButton];
    [_groupSubmitButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_groupSubmitButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_groupSubmitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_groupSubmitTableview withOffset:10.0f];
    [_groupSubmitButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

#pragma mark------get UI
-(UITableView *)groupSubmitTableview
{
    if (!_groupSubmitTableview) {
        _groupSubmitTableview = [[UITableView alloc] initForAutoLayout];
        [UZCommonMethod hiddleExtendCellFromTableview:_groupSubmitTableview];
        _groupSubmitTableview.delegate = self;
        _groupSubmitTableview.dataSource = self;
        [_groupSubmitTableview setScrollEnabled:NO];
        if ([_groupSubmitTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_groupSubmitTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        if ([_groupSubmitTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_groupSubmitTableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
    }
    return _groupSubmitTableview;
}

-(UIButton *)groupSubmitButton
{
    if (!_groupSubmitButton) {
        _groupSubmitButton = [[UIButton alloc] initForAutoLayout];
        _groupSubmitButton.layer.masksToBounds = YES;
        _groupSubmitButton.layer.cornerRadius = 4.0f;
        [_groupSubmitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_groupSubmitButton setTitle:@"提交订单" forState:UIControlStateHighlighted];
        [_groupSubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_groupSubmitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_groupSubmitButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        [_groupSubmitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupSubmitButton;
}

#pragma mark------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.submitInfo.group_name
    CGFloat height = 40.0;
    if (indexPath.row == 0) {
        height = 80;
    }
    return height;
}


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize String:(NSString *) string
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_submit_cell";
    groupSubmitTableViewCell *cell=(groupSubmitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupSubmitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
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
    NSDictionary *dic = @{
                          @"count":[NSString stringWithFormat:@"%ld",(long)count],
                          @"singel_price":self.submitInfo.now_price,
                          @"group_name":self.submitInfo.group_name
                          };
    [cell configureCell:dic row:indexPath.row];
    cell.delegate = self;
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


#pragma mark------button aciton
-(void)submitAction:(UIButton*)sender
{
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"登录" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        NSLog(@"提交订单，去支付");
        NSDictionary *dic = @{
                              @"count":[NSString stringWithFormat:@"%ld",(long)count],
                              @"singel_price":self.submitInfo.now_price,
                              @"group_name":self.submitInfo.group_name,
                              @"group_id":self.submitInfo.group_id,
                              @"group_brief":self.submitInfo.group_brief,
                              @"group_endtime":self.submitInfo.group_endtime
                              };
        [self submitGetOrderId:dic];
    }
}
#pragma mark------向服务器提交生成订单号码 验证码数组
-(void)submitGetOrderId :(NSDictionary*)dic
{
//    NSLog(@"去支付");
//    NSString *url = connect_url(@"group_grab_insert");
//    NSString *totalPrice = [NSString stringWithFormat:@"%f",[dic[@"singel_price"] floatValue]*[dic[@"count"] integerValue]];
//    NSDictionary *dict = @{
//                          @"app_key":url,
//                          @"session_key":[UserModel shareInstance].session_key,
//                          @"u_id":[UserModel shareInstance].u_id,
//                          @"group_id":dic[@"group_id"],
//                          @"grab_num":dic[@"count"],
//                          @"grab_price":totalPrice
//                          };
//    [SVProgressHUD showWithStatus:@"正在提交订单" maskType:SVProgressHUDMaskTypeNone];
//    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
//        if ([param[@"code"]integerValue]==200) {
//            NSArray *passArray = [param[@"obj"] objectForKey:@"group_pass"];
//            NSString *order_id = [NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"order_id"]];
            //----生成订单  传如下一级订单号  groupPassArray-----------
            GroupPayViewController *firVC = [[GroupPayViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"确认支付" withFont:14.0f];
            firVC.dict = dic;
            [self.navigationController pushViewController:firVC animated:YES];
//            [SVProgressHUD dismiss];
//        }else{
//            [SVProgressHUD showErrorWithStatus:param[@"message"]];
//        }
//    } andErrorBlock:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:@"网络异常"];
//    }];
}

-(void)buttonActionAddSub:(NSInteger)index
{
    if (index == 1) {
        count ++;
    }else{
        if (count>1) {
            count -- ;
        }
    }
    [self.groupSubmitTableview reloadData];
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
