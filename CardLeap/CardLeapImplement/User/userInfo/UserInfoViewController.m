//
//  UserInfoViewController.m
//  CardLeap
//
//  Created by lin on 12/15/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "MySpikeListViewController.h"
#import "UserDetailInfoViewController.h"
#import "myOrderViewController.h"
#import "myOrderSeatCenterViewController.h"
#import "myOrderRoomCenterViewController.h"
#import "myOrderRoomCenterViewController.h"
#import "myCollectionCenterViewController.h"
#import "CityUserController.h"
#import "UserUpdatePasswordViewController.h"
#import "EvenMoreListViewController.h"
#import "myGroupListViewController.h"
#import "APService.h"
#import "myPointGiftViewController.h"
#import "myPointDetailViewController.h"//记录获取记录
#import "ZQFunctionWebController.h"
#pragma mark 2016.4 我的页面
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *userInfoTableview;//个人中心显示列表
@property (strong, nonatomic) UIButton *logoutButton;//注销按钮
@property (strong, nonatomic) NSArray *iconArray;//图标数组
@property (strong, nonatomic) NSArray *nameArray;//title数组
@property (strong, nonatomic) NSArray *actionArray;//权限数组
@property (copy, nonatomic) NSString *myBusinessURL;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the ∂.
    //初始化数据
    [self initData];
    //设置界面显示
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self autoJumpLogin];
    [self setHiddenTabbar:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (ApplicationDelegate.islogin == NO) {
        
    }else{
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
        self.navigationItem.rightBarButtonItem = barItem;
        [self.userInfoTableview reloadData];
        //获取用户积分数量
        [self logToGetPoint];
    }
}

#pragma mark------重新在后台走一次登录接口，获取积分数量
-(void)logToGetPoint
{
    NSString *url = connect_url(@"user_point");
    NSDictionary *dict = @{
                           @"app_key":url,
                           @"u_id":[UserModel shareInstance].u_id
                           };
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            [UserModel shareInstance].pay_point=[NSString stringWithFormat:@"%@",[param[@"obj"] objectForKey:@"user_point"]];
            [self.userInfoTableview reloadData];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    NSString *url1 = connect_url(@"mp_user_firm");
    NSDictionary *dict1 = @{
                            @"app_key":url1,
                            @"u_id":[UserModel shareInstance].u_id
                            };
    [Base64Tool postSomethingToServe:url1 andParams:dict1 isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200) {
            
            _myBusinessURL=[[param objectForKey:@"obj"]objectForKey:@"user_business"];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常"];
    }];
    
}

-(void)autoJumpLogin
{
    if (ApplicationDelegate.islogin == NO) {
        LoginViewController *firVC = [[LoginViewController alloc] init];
        [firVC setNavBarTitle:@"登录" withFont:14];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

#pragma mark-----------初始化数据
-(void)initData
{
    //-------user info------
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"configuration" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *ItemImages = [data objectForKey:@"userIcon"];
    NSArray *ItemNames = [data objectForKey:@"userText"];
    NSArray *ItemAction = [data objectForKey:@"userShake"];
    
    _iconArray = [[NSArray alloc] initWithArray:ItemImages];
    _nameArray = [[NSArray alloc] initWithArray:ItemNames];
    _actionArray = [[NSArray alloc] initWithArray:ItemAction];
}

#pragma mark-----------set UI
-(void)setUI
{
    [self setNavBarTitle:@"个人中心" withFont:14.0f];
    [self.view addSubview:self.userInfoTableview];
    [_userInfoTableview autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:44.0];
    [_userInfoTableview autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
    [_userInfoTableview autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
    [_userInfoTableview autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:-1.0];
    //logout button
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
    self.navigationItem.rightBarButtonItem = barItem;
}

#pragma mark-----------get UI
-(UITableView *)userInfoTableview
{
    if (!_userInfoTableview) {
        _userInfoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, 0, 0) style:UITableViewStyleGrouped];
        //_userInfoTableview.layer.borderWidth = 1;
        //_userInfoTableview.style = UITableViewStyleGrouped;
        _userInfoTableview.translatesAutoresizingMaskIntoConstraints = NO;
        _userInfoTableview.delegate = self;
        _userInfoTableview.dataSource = self;
        //_userInfoTableview.scrollEnabled = NO;
        //_userInfoTableview.separatorInset = UIEdgeInsetsZero;
        [UZCommonMethod hiddleExtendCellFromTableview:_userInfoTableview];
    }
    return _userInfoTableview;
}

-(UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [_logoutButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    NSString *title ;
    if (ApplicationDelegate.islogin == YES) {
        title = @"注销";
    }else{
        title = @"登录";
    }
    [_logoutButton setTitle:title forState:UIControlStateNormal];
    [_logoutButton setTitle:title forState:UIControlStateHighlighted];
    return _logoutButton;
}

#pragma mark----设置别名
-(void)setAlian :(NSString*)alian
{
    [APService setTags:nil
                 alias:alian
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
}

#pragma mark---------设备号获取以及回调函数
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark-----------tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (ApplicationDelegate.islogin == YES) {
        NSLog(@"点击跳转很多地方");
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            //个人信息
            UserDetailInfoViewController *firVC = [[UserDetailInfoViewController alloc] init];
            [firVC setHiddenTabbar:YES];
            [firVC setNavBarTitle:@"查看资料" withFont:14.0f];
            [self.navigationController pushViewController:firVC animated:YES];
        }else{
            NSString *action;
            if (indexPath.section == 0) {
                action = [_actionArray objectAtIndex:indexPath.section*2+indexPath.row-1];
            }else{
                action = [_actionArray objectAtIndex:indexPath.section*2+indexPath.row-1];
            }
            [self actionJump:action];
        }
    }else{
        NSLog(@"滚去登录吧");
        LoginViewController *firVC = [[LoginViewController alloc] init];
        firVC.navigationItem.title = @"登录";
        firVC.identifier = @"0";
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

#pragma mark------判断跳转
-(void)actionJump :(NSString*)text
{
    if([text isEqualToString:@"group"])//跳转团购
    {
        myGroupListViewController *firVC = [[myGroupListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"我的团购" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([text isEqualToString:@"take_out"]){
        myOrderViewController *firVC = [[myOrderViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"我的外卖" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([text isEqualToString:@"seat"]){
        myOrderSeatCenterViewController *firVC = [[myOrderSeatCenterViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"我的订座" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([text isEqualToString:@"hotel"]){
        myOrderRoomCenterViewController *firVC = [[myOrderRoomCenterViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"预定酒店" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([text isEqualToString:@"spike"]){
        MySpikeListViewController *firVC = [[MySpikeListViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"我的优惠券" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
#pragma mark --- 这里设置个人业务跳转页面
    }else if([text isEqualToString:@"my_business"]){
        
        ZQFunctionWebController *firVC=[[ZQFunctionWebController alloc]init];
        firVC.url=_myBusinessURL;
        firVC.title=@"个人业务";
        [self.navigationController pushViewController:firVC animated:YES];
        
    }else if ([text isEqualToString:@"collection"]){
        myCollectionCenterViewController *firVC = [[myCollectionCenterViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"我的收藏" withFont:14.0f];
        [self.navigationController pushViewController:firVC animated:YES];
    }else if ([text isEqualToString:@"release"]){
        // 我的发布
        CityUserController *cityUser = [[CityUserController alloc] init];
        [self.navigationController pushViewController:cityUser animated:YES];
    }else if ([text isEqualToString:@"password"]){
        // 修改密码
        UserUpdatePasswordViewController *updatePasswore = [[UserUpdatePasswordViewController alloc] init];
        [self.navigationController pushViewController:updatePasswore animated:YES];
    }else if ([text isEqualToString:@"more"]){
        // 更多
        EvenMoreListViewController *evenMore = [[EvenMoreListViewController alloc] init];
        [self.navigationController pushViewController:evenMore animated:YES];
    }else if ([text isEqualToString:@"gift"]){
        //礼品中心
        NSLog(@"跳转礼品中心");
        myPointGiftViewController *firVC = [[myPointGiftViewController alloc] init];
        [firVC setNavBarTitle:@"礼品中心" withFont:14.0f];
        [firVC setHiddenTabbar:YES];
        [self.navigationController pushViewController:firVC animated:YES];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0.1;
//    }else{
//        return 10;
//    }
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 100;
    }else{
        return 40.0f;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier=@"index_cell";
    UITableViewCell *cell=(UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: simpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject]!= nil) {
        [[cell.contentView.subviews lastObject]removeFromSuperview];
    }
    if (indexPath.row == 0 && indexPath.section == 0) {
        //背景图片
        UIImageView *backgroundImage = [[UIImageView alloc] initForAutoLayout];
        [cell.contentView addSubview:backgroundImage];
        backgroundImage.image = [UIImage imageNamed:@"dividual_bg"];
        [backgroundImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
        [backgroundImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
        [backgroundImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
        [backgroundImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
        //用户头像
        UIImageView *user_pic = [[UIImageView alloc] initForAutoLayout];
        [cell.contentView addSubview:user_pic];
        [user_pic sd_setImageWithURL:[NSURL URLWithString:[UserModel shareInstance].user_pic] placeholderImage:[UIImage imageNamed:@"user"]];
        user_pic.layer.masksToBounds = YES;
        user_pic.layer.cornerRadius = 35.0f;
        user_pic.layer.borderColor = [UIColor whiteColor].CGColor;
        user_pic.layer.borderWidth = 1;
        [user_pic autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
        [user_pic autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
        [user_pic autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.f];
        [user_pic autoSetDimension:ALDimensionWidth toSize:70.0f];
        //用户名
        UILabel *user_name = [[UILabel alloc] initForAutoLayout];
        user_name.font = [UIFont systemFontOfSize:15.0f];
        user_name.textColor = [UIColor whiteColor];
        user_name.text = [NSString stringWithFormat:@"用户名:%@",[UserModel shareInstance].user_nickname];
        [cell.contentView addSubview:user_name];
        [user_name autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [user_name autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:user_pic withOffset:20.0f];
        [user_name autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
        [user_name autoSetDimension:ALDimensionHeight toSize:30.0f];
        //用户积分显示及积分数
        UILabel *user_tel = [[UILabel alloc] initForAutoLayout];
        user_tel.font = [UIFont systemFontOfSize:15.0f];
        user_tel.textColor = [UIColor whiteColor];
        user_tel.numberOfLines = 1;
        user_tel.text = @"积分:";
        [cell.contentView addSubview:user_tel];
        [user_tel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:user_pic withOffset:20.0f];
        [user_tel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:user_name withOffset:15.0f];
        [user_tel autoSetDimension:ALDimensionHeight toSize:30.0f];
        [user_tel autoSetDimension:ALDimensionWidth toSize:40.0f];
        
        UILabel *my_point = [[UILabel alloc] initForAutoLayout];
        my_point.font = [UIFont systemFontOfSize:15.0f];
        my_point.textColor = UIColorFromRGB(0x3dd5e8);
        my_point.text = [UserModel shareInstance].pay_point;
        [cell.contentView addSubview:my_point];
        [my_point autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:user_tel withOffset:2.0f];
        [my_point autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:user_name withOffset:15.0f];
        [my_point autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
        [my_point autoSetDimension:ALDimensionHeight toSize:30.0f];
        my_point.userInteractionEnabled = YES;
        UITapGestureRecognizer *tmp_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getPointList)];
        [my_point addGestureRecognizer:tmp_gesture];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (ApplicationDelegate.islogin != YES) {
            user_pic.image = [UIImage imageNamed:@"user"];
            user_name.text = @"您尚未登录,点击右上角登录";
            user_tel.hidden = YES;
            my_point.hidden = YES;
        }
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        //取数据
        NSString *imageName;
        NSString *titleName;
        if (indexPath.section == 0) {
            imageName = [_iconArray objectAtIndex:indexPath.section*2+indexPath.row-1];
            titleName = [_nameArray objectAtIndex:indexPath.section*2+indexPath.row-1];
        }else{
            imageName = [_iconArray objectAtIndex:indexPath.section*2+indexPath.row-1];
            titleName = [_nameArray objectAtIndex:indexPath.section*2+indexPath.row-1];
        }
        UIImageView *iconImage = [[UIImageView alloc] initForAutoLayout];
        iconImage.image = [UIImage imageNamed:imageName];
        [cell.contentView addSubview:iconImage];
        [iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f];
        [iconImage autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [iconImage autoSetDimension:ALDimensionWidth toSize:20.0f];
        //标签
        UILabel *nameLable = [[UILabel alloc] initForAutoLayout];
        nameLable.text = titleName;
        nameLable.font = [UIFont systemFontOfSize:14.0f];
        nameLable.textColor = UIColorFromRGB(0x606366);
        [cell.contentView addSubview:nameLable];
        [nameLable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
        [nameLable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
        [nameLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconImage withOffset:18.0f];
        [nameLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:30.0f];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return 1;
    }else{
        return 2;
    }
    //return [_iconArray count]+1;
}
#pragma mark-------action
#pragma mark --- 注销在这里
-(void)logoutAction :(UIButton*)sender
{
    if(ApplicationDelegate.islogin == YES){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认注销吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
        NSLog(@"去登录接口");
        LoginViewController *firVC = [[LoginViewController alloc] init];
        firVC.navigationItem.title = @"登录";
        firVC.identifier = @"0";
        [self.navigationController pushViewController:firVC animated:YES];
    }


    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        ApplicationDelegate.islogin = NO;
        [self.userInfoTableview reloadData];
        NSLog(@"注销了,要重新登录");
        [self setAlian:@"0"];
        self.logoutButton = nil;
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.logoutButton];
        self.navigationItem.rightBarButtonItem = barItem;
    }
}

#pragma mark------跳转积分详细列表
-(void)getPointList
{
    NSLog(@"获取积分来源明细");
    myPointDetailViewController *firVC = [[myPointDetailViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"积分记录" withFont:14.0];
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
