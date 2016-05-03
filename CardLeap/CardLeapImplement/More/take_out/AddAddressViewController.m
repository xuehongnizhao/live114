//
//  AddAddressViewController.m
//  CardLeap
//
//  Created by lin on 1/4/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
@property (strong, nonatomic) UITextField *address_T;
@property (strong, nonatomic) UITextField *phone_T;
@property (strong, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) UIView *textFieldView;
@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---------set UI
-(void)setUI
{
    [self.view addSubview:self.textFieldView];
    [_textFieldView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.0f];
    [_textFieldView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_textFieldView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_textFieldView autoSetDimension:ALDimensionHeight toSize:80.5f];
    
    //添加地址和电话栏
    [_textFieldView addSubview:self.address_T];
    [_address_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_address_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_address_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_address_T autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [_textFieldView addSubview:self.phone_T];
    [_phone_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_phone_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_phone_T autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_phone_T autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_address_T withOffset:0.5f];
    
    //确认按钮
    [self.view addSubview:self.confirmButton];
    [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [_confirmButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f];
    [_confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_textFieldView withOffset:15.0f];
    [_confirmButton autoSetDimension:ALDimensionHeight toSize:40.0f];
}

#pragma mark---------get UI
-(UIView *)textFieldView
{
    if (!_textFieldView) {
        _textFieldView = [[UIView alloc] initForAutoLayout];
        _textFieldView.layer.borderWidth = 0.5f;
        _textFieldView.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
        _textFieldView.layer.masksToBounds = YES;
        _textFieldView.layer.cornerRadius = 4.0f;
        _textFieldView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    }
    return _textFieldView;
}

-(UITextField *)phone_T
{
    if (!_phone_T) {
        _phone_T = [[UITextField alloc] initForAutoLayout];
        _phone_T.placeholder = @"请填写";
        //_phone_T.borderStyle=UITextBorderStyleRoundedRect;
        _phone_T.clearsOnBeginEditing=YES;
        _phone_T.tag=1;
        _phone_T.keyboardType=UIKeyboardTypeNumberPad;
        _phone_T.backgroundColor = [UIColor whiteColor];
        _phone_T.leftViewMode = UITextFieldViewModeAlways;
        [_phone_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.font = [UIFont systemFontOfSize:13.0f];
        leftLable.text = @"送餐电话:";
        _phone_T.leftView = leftLable;
    }
    return _phone_T;
}

-(UITextField *)address_T
{
    if (!_address_T) {
        _address_T = [[UITextField alloc] initForAutoLayout];
        _address_T.placeholder = @"请填写";
        //_address_T.borderStyle=UITextBorderStyleRoundedRect;
        _address_T.clearsOnBeginEditing=YES;
        _address_T.tag=1;
        _address_T.backgroundColor = [UIColor whiteColor];
        _address_T.leftViewMode = UITextFieldViewModeAlways;
        [_address_T setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"placeholderLabel.font"];
        UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.textColor = UIColorFromRGB(0x484848);
        leftLable.font = [UIFont systemFontOfSize:13.0f];
        leftLable.text = @"送餐地址:";
        _address_T.leftView = leftLable;
    }
    return _address_T;
}

-(UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initForAutoLayout];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 4.0f;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitle:@"确定" forState:UIControlStateHighlighted];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_confirmButton setBackgroundColor:UIColorFromRGB(0x79c5d3)];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_confirmButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

#pragma mark--------click action
-(void)submitAction:(UIButton*)sender
{
    NSLog(@"添加收获地址");
    if ([self checkValue]) {
        NSString *address = _address_T.text;
        NSString *phone = _phone_T.text;
        NSString *url = connect_url(@"takeout_address_insert");
        NSDictionary *dict = @{
                               @"app_key":url,
                               @"u_id":[UserModel shareInstance].u_id,
                               @"session_key":[UserModel shareInstance].session_key,
                               @"as_address":address,
                               @"as_tel":phone
                               };
        [SVProgressHUD showWithStatus:@"正在添加地址，请稍后"];
        [Base64Tool postSomethingToServe:url andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200) {
                [SVProgressHUD dismiss];
                [self.delegate addAddressDelegate];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络异常"];
        }];
    }
}

-(BOOL)checkValue
{
    NSString *phone = _phone_T.text;
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phone];
    if (!isMatch) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
//        [alert show];
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return NO;
    }
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
