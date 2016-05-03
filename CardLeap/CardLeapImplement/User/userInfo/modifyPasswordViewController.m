//
//  modifyPasswordViewController.m
//  CardLeap
//
//  Created by mac on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "modifyPasswordViewController.h"

@interface modifyPasswordViewController ()
@property (strong,nonatomic)UIView *blankView;//背景view
@property (strong,nonatomic)UIButton *nextStepButton;//确认按钮
@property (strong,nonatomic)UITextField *user_phone_T;//用户名输入框
@property (strong,nonatomic)UITextField *certifyCode;//密码框
@end

@implementation modifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        _user_phone_T.placeholder = @"输入密码";
        //_user_phone_T.keyboardType=UIKeyboardTypeNumberPad;
        //        _user_phone_T.layer.masksToBounds = YES;
        //        _user_phone_T.layer.cornerRadius = 4.0;
        _user_phone_T.leftViewMode = UITextFieldViewModeAlways;
        //_user_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        [_user_phone_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        
        UIImageView *passImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_password"]];
        CGRect rect = passImage.frame;
        rect.origin.x += 7;
        rect.origin.y += 5;
        passImage.frame = rect;
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [myView addSubview:passImage];
        _certifyCode.leftView = myView;
        
        _user_phone_T.backgroundColor = [UIColor whiteColor];
    }
    return _user_phone_T;
}

-(UITextField *)certifyCode
{
    if (!_certifyCode) {
        _certifyCode = [[UITextField alloc] initForAutoLayout];
        _certifyCode = [[UITextField alloc] initForAutoLayout];
        _certifyCode.placeholder = @"确认密码";
        //_certifyCode.layer.masksToBounds = YES;
        //_certifyCode.layer.cornerRadius = 4.0;
        _certifyCode.backgroundColor = [UIColor whiteColor];
        //_certifyCode.keyboardType=UIKeyboardTypeNumberPad;
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
    }
    return _certifyCode;
}

-(UIButton *)nextStepButton
{
    if (!_nextStepButton) {
        _nextStepButton = [[UIButton alloc] initForAutoLayout];
        _nextStepButton.layer.masksToBounds = YES;
        _nextStepButton.layer.cornerRadius = 4.0f;
        [_nextStepButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"确认修改" forState:UIControlStateHighlighted];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_nextStepButton setBackgroundColor:UIColorFromRGB(0x76c3d2)];
        [_nextStepButton addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
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

#pragma mark------modify action
-(void)modifyAction:(UIButton*)sender
{
    NSLog(@"确认修改");
    if ([self.user_phone_T.text isEqualToString:self.certifyCode.text]) {
        NSString *url = connect_url(@"yz_edit_pass");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"user_name":self.user_tel,
                               @"user_pass":_user_phone_T.text,
                               @"user_pass2":_certifyCode.text
                               };
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
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
