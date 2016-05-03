//
//  LoginViewController.m
//  CardLeap
//
//  Created by lin on 12/12/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "LoginViewController.h"
#import "UserModel.h"
//三方登录按钮
#import "LoginMethodButtonView.h"
//注册
#import "RegistViewController.h"
//友盟
#import "UMSocial.h"
//绑定手机号
#import "BindPhoneViewController.h"
#import "TabBarViewController.h"
//忘记密码
#import "ForgetPasswordViewController.h"
#import "APService.h"

@interface LoginViewController ()<UITextFieldDelegate,clickButtonDelegate,UMSocialUIDelegate>
{
    UITextField *_userName;//用户名
    UITextField *_passWord;//密码
    UIButton *_rememberButton;//记住密码
    UIButton *_forgetButton;//忘记密码
    UIButton *_loginButton;//登录按钮
    UILabel *_loginTitle;//三方登录
    UIView *_loginToolView;//三方登录view
    UserModel *ud;//用户信息
}
@end

@implementation LoginViewController
@synthesize identifier = _identifier;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ud = [UserModel shareInstance];
    [self setUI];
}
#pragma mark---------设置登录界面
-(void)setUI
{
    if ([_identifier isEqualToString:@"1"]) {
        [self.navigationItem setHidesBackButton:YES];
    }
    //各种控件的自动布局
    //用户手机号
    [self.view addSubview:[self userName]];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [[self userName] autoSetDimension:ALDimensionHeight toSize:35.0f];
    //用户密码
    [self.view addSubview:[self passWord]];
    [[self passWord] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [[self passWord] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [[self passWord] autoSetDimension:ALDimensionHeight toSize:35.0f];
    [[self passWord] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self userName] withOffset:5.0];
    //登录密码
    [self.view addSubview:[self loginButton]];
    [[self loginButton] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [[self loginButton] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [[self loginButton] autoSetDimension:ALDimensionHeight toSize:35.0f];
    [[self loginButton] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self passWord] withOffset:15.0];
    //忘记密码 三方登录框
    [self.view addSubview:[self loginTitle]];
    [[self loginTitle] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [[self loginTitle] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self loginButton] withOffset:10.0f];
    [[self loginTitle] autoSetDimension:ALDimensionHeight toSize:15.0f];
    [[self loginTitle] autoSetDimension:ALDimensionWidth toSize:200.0f];
    
    [self.view addSubview:[self forgetButton]];
    [[self forgetButton] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [[self forgetButton] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self loginButton] withOffset:10.0f];
    [[self forgetButton] autoSetDimension:ALDimensionHeight toSize:15.0f];
    [[self forgetButton] autoSetDimension:ALDimensionWidth toSize:100.0f];
    //三方登录按钮
    [self.view addSubview:[self loginToolView]];
    [[self loginToolView]autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self forgetButton] withOffset:10.0f];
    [[self loginToolView] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [[self loginToolView] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [[self loginToolView] autoSetDimension:ALDimensionHeight toSize:35.0f];
    //设置注册按钮
    [self setSign];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------注册按钮 及 方法
-(void)setSign
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitle:@"注册" forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *signButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = signButton;
}

-(void)sign :(UIButton*)sender
{
    RegistViewController *firVC = [[RegistViewController alloc] init];
    [firVC setNavBarTitle:@"注册" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"注册"];
    [firVC.navigationItem setHidesBackButton:NO];
    firVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:firVC animated:YES];
}

#pragma mark---------各种控件的布局
-(UITextField*)passWord
{
    if (!_passWord) {
        _passWord = [[UITextField alloc] initForAutoLayout];
        _passWord.delegate=self;
        _passWord.placeholder=@"请输入密码";
        _passWord.borderStyle=UITextBorderStyleRoundedRect;
        _passWord.clearsOnBeginEditing=YES;
        _passWord.tag=1;
        _passWord.secureTextEntry=YES;
        _passWord.tintColor = UIColorFromRGB(tintColors);
        [_passWord setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passWord setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _passWord.layer.masksToBounds = YES;
        _passWord.layer.cornerRadius = 4.0;
        _passWord.leftViewMode = UITextFieldViewModeAlways;
        [_passWord setValue:[UIFont systemFontOfSize:13.0] forKeyPath:@"placeholderLabel.font"];
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        CGRect rect = passImage.frame;
        rect.origin.x = rect.origin.x + 7;
        rect.origin.y += 5;
        passImage.frame = rect;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [myView addSubview:passImage];
        _passWord.leftView = myView;
        if (userDefault(@"PASSWORD")!=nil) {
            _passWord.text=userDefault(@"PASSWORD");
        }
    }
    return _passWord;
}

-(UITextField*)userName
{
    if (!_userName) {
        _userName = [[UITextField alloc] initForAutoLayout];
        _userName.delegate=self;
        _userName.placeholder=@"输入注册的手机号";
        _userName.borderStyle=UITextBorderStyleRoundedRect;
        _userName.clearsOnBeginEditing=YES;
        _userName.tag=1;
        _userName.keyboardType=UIKeyboardTypeNumberPad;
        _userName.layer.masksToBounds = YES;
        _userName.layer.cornerRadius = 4.0;
        _userName.leftViewMode = UITextFieldViewModeAlways;
        _userName.tintColor = UIColorFromRGB(tintColors);
        [_userName setValue:[UIFont systemFontOfSize:13.0] forKeyPath:@"placeholderLabel.font"];
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        CGRect rect = passImage.frame;
        rect.origin.x += 7;
        rect.origin.y += 5;
        passImage.frame = rect;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [myView addSubview:passImage];
        _userName.leftView = myView;
        if (userDefault(@"USERNAME")!=nil) {
            _userName.text=userDefault(@"USERNAME");
        }
    }
    return _userName;
}

-(UIButton*)loginButton
{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initForAutoLayout];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateHighlighted];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_loginButton setTintColor:[UIColor whiteColor]];
        [_loginButton setBackgroundColor:UIColorFromRGB(0x76c3d2)];
        [_loginButton.layer setMasksToBounds:YES];
        [_loginButton.layer setCornerRadius:4.0f];
        [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(UIButton*)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] initForAutoLayout];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateHighlighted];
        [_forgetButton setTitleColor:UIColorFromRGB(0xc7373b) forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_forgetButton addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}

-(UILabel*)loginTitle
{
    if (!_loginTitle) {
        _loginTitle = [[UILabel alloc] initForAutoLayout];
        _loginTitle.text = @"其他登录方式";
        _loginTitle.textColor = [UIColor lightGrayColor];
        _loginTitle.font = [UIFont systemFontOfSize:13.0f];
    }
    return _loginTitle;
}

-(UIView*)loginToolView
{
    if (!_loginToolView) {
        _loginToolView = [[UIView alloc] initForAutoLayout];
        _loginToolView.layer.borderWidth = 1;
        _loginToolView.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
        _loginToolView.layer.masksToBounds = YES;
        _loginToolView.layer.cornerRadius = 4.0f;
        _loginToolView.backgroundColor = [UIColor whiteColor];
        NSArray *nameArray = @[@"",@"",@""];//可以添加标题
        NSArray *imageArray = @[@"login_qq",@"login_wx",@"login_sina"];
        CGFloat width = (SCREEN_WIDTH -20-80*3)/2;
        //添加各种登录方式button
        for (int i=0; i<3; i++) {
            int x_pos = width + 80*i;
            LoginMethodButtonView *logButton = [[LoginMethodButtonView alloc] initWithFrame:CGRectMake(x_pos, 5.0f, 80, 25.0f)];
            logButton.delegate = self;
            [logButton setButtonViewTag:i+1];
            [logButton setButtonImage:[imageArray objectAtIndex:i] text:[nameArray objectAtIndex:i]];
            //[logButton addTarget:self action:@selector(loginMethodAction:)];
            [_loginToolView addSubview:logButton];
        }
    }
    return _loginToolView;
}
#pragma mark-------登录按钮
-(void)login :(UIButton*)sender
{
    if ([self userName].text.length > 0 && [self passWord].text.length > 0) {
        NSString *baidu_id = @"0";
        NSDictionary *dic = @{
                              @"app_key":USER_LOGIN,
                              @"user_name":[self userName].text,
                              @"user_pass":[self passWord].text,
                              @"reg_type":@"0",
                              @"th_id":@"0",
                              @"baidu_id":baidu_id
                              };
        [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
        [Base64Tool postSomethingToServe:USER_LOGIN andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
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
    }else{
        [SVProgressHUD showErrorWithStatus:@"请正确填写用户名和密码"];
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
    NSString *userName = self.userName.text;
    NSString *passWord = self.passWord.text;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AUTOLOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //跳转个人信息界面
    NSLog(@"登录成功了，该去做点别的了");
    NSString *baidu_id = userDefault(@"baidu_id");
    
    baidu_id = [NSString stringWithFormat:@"%@%@",baidu_id,[UserModel shareInstance].u_id];
    [self setAlian:baidu_id];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-------三方登录按钮delegate
-(void)clickAction:(NSInteger)tag
{
    NSLog(@"%ld",(long)tag);
    NSString *platformName;
    if (tag == 1) {
        //qq
        platformName = @"qq";
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"login response is %@",response);
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                [self thirdLogin:snsAccount.usid type:@"1"];
            }
        });
    }else if (tag == 2){
        //微信
        platformName = @"wxsession";
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"login response is %@",response);
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                [self thirdLogin:snsAccount.usid type:@"3"];
            }
        });
    }else if (tag == 3){
        //微博
        platformName = @"sina";
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"login response is %@",response);
            //          获取微博用户名、uid、token等
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                [self thirdLogin:snsAccount.usid type:@"2"];
            }
        });
    }
}
#pragma mark------登录验证
-(void)thirdLogin :(NSString*)usid type:(NSString*)type
{
    NSString *baidu_id = @" ";
    NSDictionary *dic = @{
                          @"app_key":USER_LOGIN,
                          @"user_name":@"0",
                          @"user_pass":@"0",
                          @"reg_type":type,
                          @"th_id":usid,
                          @"baidu_id":baidu_id
                          };
    [SVProgressHUD showWithStatus:@"授权成功，正在登录" maskType:SVProgressHUDMaskTypeClear];
    [Base64Tool postSomethingToServe:USER_LOGIN andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            //登录成功,获取用户信息
            [SVProgressHUD dismiss];
            NSDictionary *userDic = [param objectForKey:@"obj"];
            [self loginSuccess:userDic];
        }else if ([code isEqualToString:@"400"]){
            [SVProgressHUD dismiss];
            if ([[param[@"obj"] objectForKey:@"type"] integerValue] == 1) {
                //跳转第三方登录绑定界面
                BindPhoneViewController *firVC = [[BindPhoneViewController alloc] init];
                firVC.navigationItem.title = @"绑定手机";
                firVC.usid = usid;
                firVC.type = type;
                [self.navigationController pushViewController:firVC animated:YES];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，请稍后重试"];
    }];
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

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"%@",response);
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"maybe do something...");
}

-(void)forgetAction:(UIButton*)sender
{
    NSLog(@"忘记密码");
    ForgetPasswordViewController *firVC = [[ForgetPasswordViewController alloc] init];
    [firVC setHiddenTabbar:YES];
    [firVC setNavBarTitle:@"忘记密码" withFont:14.0f];
    //    [firVC.navigationItem setTitle:@"忘记密码"];
    [self.navigationController  pushViewController:firVC animated:YES];
}


@end
