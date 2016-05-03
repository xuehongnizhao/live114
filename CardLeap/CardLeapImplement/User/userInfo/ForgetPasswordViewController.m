//
//  ForgetPasswordViewController.m
//  CardLeap
//
//  Created by mac on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "modifyPasswordViewController.h"

@interface ForgetPasswordViewController ()
{
    NSString *_checkCode;//验证码
}
@property (strong,nonatomic)UIView *blankView;//
@property (strong,nonatomic)UIButton *nextStepButton;//下一步按钮
@property (strong,nonatomic)UITextField *user_phone_T;//用户名
@property (strong,nonatomic)UITextField *certifyCode;//验证码输入框
@property (strong,nonatomic)UIButton *getCodeButton;//获取验证码按钮
@end

@implementation ForgetPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------get UI
-(UIView *)blankView
{
    if (!_blankView) {
        _blankView = [[UIView alloc] initForAutoLayout];
        _blankView.backgroundColor = [UIColor lightGrayColor];
        _blankView.layer.borderWidth = 0.5;
        _blankView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _blankView.layer.masksToBounds = YES;
        _blankView.layer.cornerRadius = 4.0f;
    }
    return _blankView;
}

-(UITextField *)user_phone_T
{
    if (!_user_phone_T) {
        _user_phone_T = [[UITextField alloc] initForAutoLayout];
        _user_phone_T.placeholder = @"输入注册的手机号码";
        _user_phone_T.keyboardType=UIKeyboardTypeNumberPad;
//        _user_phone_T.layer.masksToBounds = YES;
//        _user_phone_T.layer.cornerRadius = 4.0;
        _user_phone_T.leftViewMode = UITextFieldViewModeAlways;
        //_user_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        [_user_phone_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_ueer"]];
        CGRect rect = passImage.frame;
        rect.origin.x += 7;
        rect.origin.y += 5;
        passImage.frame = rect;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [myView addSubview:passImage];
        
        _user_phone_T.leftView = myView;
        _user_phone_T.backgroundColor = [UIColor whiteColor];
    }
    return _user_phone_T;
}

-(UITextField *)certifyCode
{
    if (!_certifyCode) {
        _certifyCode = [[UITextField alloc] initForAutoLayout];
        _certifyCode = [[UITextField alloc] initForAutoLayout];
        _certifyCode.placeholder = @"输入验证码";
//        _certifyCode.layer.masksToBounds = YES;
//        _certifyCode.layer.cornerRadius = 4.0;
        _certifyCode.backgroundColor = [UIColor whiteColor];
        _certifyCode.keyboardType=UIKeyboardTypeNumberPad;
        //_certifyCode.borderStyle=UITextBorderStyleRoundedRect;
        [_certifyCode setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        _certifyCode.leftViewMode = UITextFieldViewModeAlways;
        
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"register_code"]];
        CGRect rect = passImage.frame;
        rect.origin.x += 7;
        rect.origin.y += 5;
        passImage.frame = rect;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [myView addSubview:passImage];
        _certifyCode.leftView = myView;
        
        _certifyCode.rightViewMode = UITextFieldViewModeAlways;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(165, 0, 114, 39);
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(getVerfiryCode:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:UIColorFromRGB(0xe34a51)];
        _certifyCode.rightView = button;
    }
    return _certifyCode;
}

-(UIButton *)nextStepButton
{
    if (!_nextStepButton) {
        _nextStepButton = [[UIButton alloc] initForAutoLayout];
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.layer.cornerRadius = 4.0f;
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateHighlighted];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_nextStepButton setBackgroundColor:UIColorFromRGB(0x76c3d2)];
        [_nextStepButton addTarget:self action:@selector(nextStepAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}


-(UIButton *)getCodeButton
{
    if (!_getCodeButton) {
        _getCodeButton = [[UIButton alloc] initForAutoLayout];
    }
    return _getCodeButton;
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view setBackgroundColor:UIColorFromRGB(0xf3f3f3)];
    [self.view addSubview:self.blankView];
    [_blankView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_blankView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_blankView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [_blankView autoSetDimension:ALDimensionHeight toSize:100.0f];
    
    [_blankView addSubview:self.user_phone_T];
    [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_user_phone_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_user_phone_T autoSetDimension:ALDimensionHeight toSize:50.0f];
    
    [_blankView addSubview:self.certifyCode];
    [_certifyCode autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_certifyCode autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_certifyCode autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f];
    [_certifyCode autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_user_phone_T withOffset:0.5f];
    
    [self.view addSubview:self.nextStepButton];
    [_nextStepButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_nextStepButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_nextStepButton autoSetDimension:ALDimensionHeight toSize:45.0f];
    [_nextStepButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_blankView withOffset:15.0f];
}

#pragma mark----------button action
#pragma mark-------获取验证码
-(void)getVerfiryCode :(UIButton*)sender
{
    NSLog(@"获取验证码");
    if ([self checkTel:self.user_phone_T.text]==YES)
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
                    sender.userInteractionEnabled = NO;
                    [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        NSString* user_name=self.user_phone_T.text;
        NSDictionary* dict=@{
                             @"user_name":user_name,
                             @"app_key":GET_SECURITY_CODE,
                             @"type":@"2"
                             };
        [Base64Tool postSomethingToServe:GET_SECURITY_CODE andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            NSDictionary* dic=(NSDictionary*)param;
            if ([param[@"code"] integerValue]==200) {
                NSLog(@"get message:%@",[dic  objectForKey:@"message"]);
                _checkCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"obj"]];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力,稍后重试"];
        }];
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

    return YES;
}


-(void)nextStepAction:(UIButton*)sender
{
    NSLog(@"下一步");
    if ([_checkCode isEqualToString:self.certifyCode.text]) {
        NSLog(@"验证成功，进入下一个界面");
        modifyPasswordViewController *firVC = [[modifyPasswordViewController alloc] init];
        [firVC setHiddenTabbar:YES];
        [firVC setNavBarTitle:@"修改密码" withFont:14.0f];
//        [firVC.navigationItem setTitle:@"修改密码"];
        firVC.user_tel = self.user_phone_T.text;
        [self.navigationController pushViewController:firVC animated:YES];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确验证码"];
    }
}


@end
