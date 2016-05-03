//
//  BindPhoneViewController.m
//  CardLeap
//
//  Created by lin on 12/16/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "RegistViewController.h"
#import "APService.h"

@interface BindPhoneViewController ()
@property (strong, nonatomic) NSString *checkCode;//验证码
@property (strong, nonatomic) UITextField *userName;//用户名
@property (strong, nonatomic) UITextField *passWord;//密码
@property (strong, nonatomic) UITextField *verifyCode;//验证码输入框
@property (strong, nonatomic) UIButton *registButton;//绑定按钮
@property (strong, nonatomic) UILabel *hintLable;//提示lable
@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

#pragma mark-------界面布局
-(void)setUI
{
    //用户手机号
    [self.view addSubview:[self userName]];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [[self userName] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [[self userName] autoSetDimension:ALDimensionHeight toSize:35.0f];
    //用户密码
    [self.view addSubview:[self passWord]];
    [[self passWord] autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [[self passWord] autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [[self passWord] autoSetDimension:ALDimensionHeight toSize:35.0f];
    [[self passWord] autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:[self userName] withOffset:5.0];
    //验证码
    [self.view addSubview:self.verifyCode];
    [_verifyCode autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_verifyCode autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_verifyCode autoSetDimension:ALDimensionHeight toSize:35.0f];
    [_verifyCode autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passWord withOffset:5.0f];
    //登录按钮
    [self.view addSubview:self.registButton];
    [_registButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_registButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_registButton autoSetDimension:ALDimensionHeight toSize:35.0f];
    [_registButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_verifyCode withOffset:10.0f];
    //提示标签
    [self.view addSubview:self.hintLable];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_hintLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_registButton withOffset:5.0f];
    [self addText:_hintLable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark----------add text
-(void)addText :(UILabel*)lable
{
    NSString *tempStr ;
    if ([self.type isEqualToString:@"1"]) {
        tempStr = @"QQ";
    }else if ([self.type isEqualToString:@"2"]){
        tempStr = @"新浪微博";
    }else{
        tempStr = @"微信";
    }
    lable.text = [NSString stringWithFormat:@"您当前使用%@平台登录成功，绑定手机下次可用手机号直接登录",tempStr];
}
#pragma mark----------get各种控件
-(UILabel *)hintLable
{
    if (!_hintLable) {
        _hintLable = [[UILabel alloc] initForAutoLayout];
        _hintLable.textColor = [UIColor lightGrayColor];
        _hintLable.font = [UIFont systemFontOfSize:13.0f];
        _hintLable.numberOfLines = 0;
    }
    return _hintLable;
}

-(UITextField *)userName
{
    if (!_userName) {
        _userName = [[UITextField alloc] initForAutoLayout];
        _userName.placeholder = @"输入注册的手机号码";
        _userName.keyboardType=UIKeyboardTypeNumberPad;
        _userName.layer.masksToBounds = YES;
        _userName.layer.cornerRadius = 4.0;
        _userName.tintColor = UIColorFromRGB(tintColors);
        _userName.leftViewMode = UITextFieldViewModeAlways;
        _userName.borderStyle=UITextBorderStyleRoundedRect;
        [_userName setValue:[UIFont systemFontOfSize:13.0] forKeyPath:@"placeholderLabel.font"];
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        passImage.frame = CGRectMake(30, 3, 20, 20);
        _userName.leftView = passImage;
        if (userDefault(@"USERNAME")!=nil) {
            _userName.text=userDefault(@"USERNAME");
        }
        _userName.rightViewMode = UITextFieldViewModeAlways;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(165, 0, 114, 39);
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(getVerfiryCode:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:UIColorFromRGB(0xe34a51)];
        _userName.rightView = button;
    }
    return _userName;
}

-(UITextField *)passWord
{
    if (!_passWord) {
        _passWord = [[UITextField alloc] initForAutoLayout];
        _passWord.placeholder = @"输入密码";
        _passWord.secureTextEntry=YES;
        _passWord.borderStyle=UITextBorderStyleRoundedRect;
        [_passWord setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_passWord setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        _passWord.layer.masksToBounds = YES;
        _passWord.tintColor = UIColorFromRGB(tintColors);
        _passWord.layer.cornerRadius = 4.0;
        _passWord.leftViewMode = UITextFieldViewModeAlways;
        [_passWord setValue:[UIFont systemFontOfSize:13.0] forKeyPath:@"placeholderLabel.font"];
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        CGRect rect = passImage.frame;
        rect.origin.x = rect.origin.x + 3;
        passImage.frame = rect;
        _passWord.leftView = passImage;
//        if (userDefault(@"PASSWORD")!=nil) {
//            _userName.text=userDefault(@"PASSWORD");
//        }
    }
    return _passWord;
}

-(UITextField *)verifyCode
{
    if (!_verifyCode) {
        _verifyCode = [[UITextField alloc] initForAutoLayout];
        _verifyCode.placeholder = @"输入验证码";
        _verifyCode.layer.masksToBounds = YES;
        _verifyCode.layer.cornerRadius = 4.0;
        _verifyCode.borderStyle=UITextBorderStyleRoundedRect;
        [_verifyCode setValue:[UIFont systemFontOfSize:13.0] forKeyPath:@"placeholderLabel.font"];
        _verifyCode.leftViewMode = UITextFieldViewModeAlways;
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_code"]];
        CGRect rect = passImage.frame;
        rect.origin.x = rect.origin.x + 3;
        passImage.frame = rect;
        _verifyCode.leftView = passImage;
    }
    return _verifyCode;
}

-(UIButton *)registButton
{
    if (!_registButton) {
        _registButton = [[UIButton alloc] initForAutoLayout];
        _registButton.layer.masksToBounds = YES;
        _registButton.layer.cornerRadius = 4.0f;
        [_registButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_registButton setTitle:@"绑定" forState:UIControlStateHighlighted];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_registButton setBackgroundColor:UIColorFromRGB(0x76c3d2)];
        [_registButton addTarget:self action:@selector(bindAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

#pragma mark---------绑定手机
-(void)bindAction :(UIButton*)sender
{
    NSLog(@"注册");
    if ([self checkLawful] == YES) {
        NSDictionary *dic = @{
                              @"app_key":REGIST_USER,
                              @"user_name":self.userName.text,
                              @"user_pass":self.passWord.text,
                              @"th_id":self.usid,
                              @"reg_type":self.type
                              };
        [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeClear];
        [Base64Tool postSomethingToServe:REGIST_USER andParams:dic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSString *code = [NSString stringWithFormat:@"%@",[param objectForKey:@"code"]];
            if ([code isEqualToString:@"200"]) {
                [SVProgressHUD dismiss];
                [self login];
            }else{
                [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];
    }

}
#pragma mark---------登录了
-(void)login
{
    NSLog(@"绑定成功，去登录");
    NSString *baidu_id = @" ";
    NSDictionary *dic = @{
                          @"app_key":USER_LOGIN,
                          @"user_name":@"0",
                          @"user_pass":@"0",
                          @"reg_type":self.type,
                          @"th_id":self.usid,
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
        }else{
            [SVProgressHUD showErrorWithStatus:[param objectForKey:@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力，请稍后重试"];
    }];

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
    //登录状态
    ApplicationDelegate.islogin = YES;
    //记录手机号，密码
    NSString *userName = self.userName.text;
    NSString *passWord = self.passWord.text;
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"ISREMEMBER"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"AUTULOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //跳转个人信息界面
    NSLog(@"登录成功了，该去做点别的了");
    
    NSString *baidu_id = userDefault(@"baidu_id");
    baidu_id = [NSString stringWithFormat:@"%@%@",baidu_id,[UserModel shareInstance].u_id];
    [self setAlian:baidu_id];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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


#pragma mark---------获取验证码
-(void)getVerfiryCode :(UIButton*)sender
{
    NSLog(@"获取验证码");
    if ([self checkTel:self.userName.text]==YES)
    {
        __block int timeout=59;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        NSString* user_name=self.userName.text;
        NSDictionary* dict=@{
                             @"user_name":user_name,
                             @"app_key":GET_SECURITY_CODE
                             };
        [Base64Tool postSomethingToServe:GET_SECURITY_CODE andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSDictionary* dic=(NSDictionary*)param;
            NSLog(@"get message:%@",[dic  objectForKey:@"message"]);
            _checkCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"obj"]];
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力,稍后重试"];
        }];
    }
    
}

#pragma mark----------检测所有输入信息
#pragma mark-------check the textFiled text
-(BOOL)checkLawful
{
    if ([self.verifyCode.text isEqualToString:_checkCode] && self.verifyCode.text.length != 0) {
        if ([self checkTel:self.userName.text]) {
            if (self.passWord.text.length!=0) {
                return YES;
            }else{
                [SVProgressHUD showErrorWithStatus:@"请输入密码"];
                return NO;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"手机号码输入不正确"];
            return NO;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"验证码输入不正确"];
        return NO;
    }
}
#pragma mark----------检查用户输入手机号，尚未确定如何验证
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"信息输入不完整" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    //    //1[0-9]{10}
    //
    //    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    //    NSString *regex = @"[0-9]{11}";
    //    NSString *regex = @"^((13[0-9])|(147)|(17[0-9])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    //    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //    BOOL isMatch = [pred evaluateWithObject:str];
    //    if (!isMatch)
    //    {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alert show];
    //        return NO;
    //    }
    //    if([passWord.text isEqualToString:@""])
    //    {
    //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    //
    //        [alert show];
    //        return NO;
    //    }
    return YES;
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
