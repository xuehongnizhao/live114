//
//  UpdateGroupViewController.m
//  CardLeap
//
//  Created by mac on 15/3/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "UpdateGroupViewController.h"
#import "groupSubmitTableViewCell.h"
#import "GroupPayViewController.h"
#import "LoginViewController.h"

@interface UpdateGroupViewController ()<UITableViewDataSource,UITableViewDelegate,groupButtonDelegate>
{
    NSInteger count;
}
@property (strong,nonatomic)UITableView *groupSubmitTableview;
@property (strong,nonatomic)UIButton *groupSubmitButton;
@end

@implementation UpdateGroupViewController

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

#pragma mark-------set data and show
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
        _groupSubmitTableview.separatorInset = UIEdgeInsetsZero;
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
    CGFloat height = 40.0;
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"group_submit_cell";
    groupSubmitTableViewCell *cell=(groupSubmitTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[groupSubmitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSDictionary *dic = @{
                          @"count":[NSString stringWithFormat:@"%ld",(long)count],
                          @"singel_price":self.myUpdateInfo.single_price,
                          @"group_name":self.myUpdateInfo.group_name
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
        //        [firVC.navigationItem setTitle:@"登录"];
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        [self updateSuccessAndJump];
    }
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

#pragma mark------跳转支付页面
-(void)updateSuccessAndJump
{
    NSDictionary *dic = @{
                          @"count":[NSString stringWithFormat:@"%ld",(long)count],
                          @"singel_price":self.myUpdateInfo.single_price,
                          @"group_name":self.myUpdateInfo.group_name,
                          @"group_id":self.myUpdateInfo.group_id,
                          @"group_brief":self.myUpdateInfo.group_brief,
                          @"group_endtime":self.myUpdateInfo.group_endtime
                          };
    GroupPayViewController *firVC = [[GroupPayViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"确认支付" withFont:14.0f];
    firVC.dict = dic;
//    firVC.order_id = self.myUpdateInfo.order_id;
//    firVC.passArray = self.myUpdateInfo.pass_array;
    [self.navigationController pushViewController:firVC animated:YES];
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
