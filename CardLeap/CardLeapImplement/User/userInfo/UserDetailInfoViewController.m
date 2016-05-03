//
//  UserDetailInfoViewController.m
//  CardLeap
//
//  Created by mac on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "UserDetailInfoViewController.h"
#import "EditUserInfoViewController.h"

@interface UserDetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *userInfoDic;
}
@property (strong,nonatomic)UITableView *userInfoDetailTableview;//个人信息列表
@property (strong,nonatomic)UIButton *leftButton;//修改个人信息按钮
@property (strong,nonatomic)UITextField *user_name_T;//用户名显示框
@property (strong,nonatomic)UITextField *user_sex_T;//用户性别显示框
@property (strong,nonatomic)UITextField *user_phone_T;//用户手机号显示框
@property (strong,nonatomic)UITextField *user_address_T;//用户地址显示框
@property (strong,nonatomic)UIImageView *user_image;//用户头像
@end

@implementation UserDetailInfoViewController

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
    [self.userInfoDetailTableview reloadData];
}

#pragma mark--------get data
-(void)getDataFromNet
{
}

#pragma mark--------get UI
-(UITableView *)userInfoDetailTableview
{
    if (!_userInfoDetailTableview) {
        _userInfoDetailTableview = [[UITableView alloc] initForAutoLayout];
        _userInfoDetailTableview.delegate = self;
        _userInfoDetailTableview.dataSource = self;
        _userInfoDetailTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_userInfoDetailTableview];
    }
    return _userInfoDetailTableview;
}

-(UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
        [_leftButton setImage:[UIImage imageNamed:@"modifydata_no"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"modifydata_sel"] forState:UIControlStateHighlighted];
        [_leftButton addTarget:self action:@selector(editMyInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

-(UITextField *)user_name_T
{
    if (!_user_name_T) {
        _user_name_T = [[UITextField alloc] initForAutoLayout];
        _user_name_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_name_T.leftViewMode = UITextFieldViewModeAlways;
        _user_name_T.enabled = NO;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_name_T.textColor = [UIColor lightGrayColor];
        _user_name_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"用户名   ";
        _user_name_T.leftView = leftLable;
    }
    return _user_name_T;
}

-(UITextField *)user_sex_T
{
    if (!_user_sex_T) {
        _user_sex_T = [[UITextField alloc] initForAutoLayout];
        _user_sex_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_sex_T.leftViewMode = UITextFieldViewModeAlways;
        _user_sex_T.enabled = NO;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_sex_T.textColor = [UIColor lightGrayColor];
        _user_sex_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"性  别   ";
        _user_sex_T.leftView = leftLable;
    }
    return _user_sex_T;
}

-(UITextField *)user_phone_T
{
    if (!_user_phone_T) {
        _user_phone_T = [[UITextField alloc] initForAutoLayout];
        _user_phone_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_phone_T.leftViewMode = UITextFieldViewModeAlways;
        _user_phone_T.enabled = NO;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_phone_T.textColor = [UIColor lightGrayColor];
        _user_phone_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"手机号   ";
        _user_phone_T.leftView = leftLable;
        
    }
    return _user_phone_T;
}

-(UITextField *)user_address_T
{
    if (!_user_address_T) {
        _user_address_T = [[UITextField alloc] initForAutoLayout];
        _user_address_T.userInteractionEnabled = [EDITENABLE boolValue];
        _user_address_T.leftViewMode = UITextFieldViewModeAlways;
        _user_address_T.enabled = NO;
        //_connect_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _user_address_T.textColor = [UIColor lightGrayColor];
        _user_address_T.font = [UIFont systemFontOfSize:14.0f];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 60, 30)];
        leftLable.font = [UIFont systemFontOfSize:14.0f];
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.text = @"地  址   ";
        _user_address_T.leftView = leftLable;
    }
    return _user_address_T;
}

-(UIImageView *)user_image
{
    if (!_user_image) {
        _user_image = [[UIImageView alloc] initForAutoLayout];
    }
    return _user_image;
}

#pragma mark--------set UI
-(void)setUI
{
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    self.navigationItem.rightBarButtonItem = leftBar;
    
    [self.view addSubview:self.userInfoDetailTableview];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_userInfoDetailTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    
}

#pragma mark--------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"干嘛的-----");
    //NSInteger row = indexPath.row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60.0;
    }
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"user_info_detail_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *titleLable = [[UILabel alloc] initForAutoLayout];
        [cell.contentView addSubview:titleLable];
        titleLable.textColor = UIColorFromRGB(0x484848);
        titleLable.font = [UIFont systemFontOfSize:15.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
        [titleLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
        [titleLable autoSetDimension:ALDimensionWidth toSize:60.0f];
        [titleLable autoSetDimension:ALDimensionHeight toSize:25.0f];
        titleLable.text = @"头像";
        
        [cell.contentView addSubview:self.user_image];
        [_user_image autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
        [_user_image autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
        [_user_image autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:titleLable withOffset:10.0f];
        [_user_image autoSetDimension:ALDimensionWidth toSize:50.0f];
        [_user_image sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        _user_image.layer.masksToBounds = YES;
        _user_image.layer.cornerRadius = 25.0f;
    }else if (section == 1){
        if (row == 0) {
            [cell.contentView addSubview:self.user_name_T];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_name_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_nickname isEqualToString:@""]) {
                _user_name_T.text = @"未填写";
            }else{
                _user_name_T.text = [UserModel shareInstance].user_nickname;
            }
        }else{
            [cell.contentView addSubview:self.user_sex_T];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_sex_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].sex integerValue]==1) {
                _user_sex_T.text = @"男";
            }else{
                _user_sex_T.text = @"女";
            }
        }
    }else if (section == 2){
        if (row == 0) {
            [cell.contentView addSubview:self.user_phone_T];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_tel isEqualToString:@""]) {
                _user_phone_T.text = @"未填写";
            }else{
                _user_phone_T.text = [UserModel shareInstance].user_name;
            }
        }else{
            [cell.contentView addSubview:self.user_address_T];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
            [_user_address_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f];
            if ([[UserModel shareInstance].user_address isEqualToString:@""]) {
                _user_address_T.text = @"未填写";
            }else{
                _user_address_T.text = [UserModel shareInstance].user_address;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }
    return 5.0f;
}

#pragma mark--------button action
-(void)editMyInfoAction:(UIButton*)sender
{
    NSLog(@"去修改信息");
    EditUserInfoViewController *firVC = [[EditUserInfoViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"修改信息" withFont:14.0f];
//    [firVC.navigationItem setTitle:@"修改信息"];
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
