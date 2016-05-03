//
//  UserUpdatePasswordViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/26.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "UserUpdatePasswordViewController.h"

#import "UserInfoViewController.h"

#define SYSTEM_FONT_SIZE(size) [UIFont systemFontOfSize:size];
#define padding 10


@interface UserUpdatePasswordViewController ()

// ---------------------- UI 控件 ----------------------
/** 添加一个背景的 view 实现圆角的效果 */
@property (weak, nonatomic) UIView      *backgroundView;
/** 原密码 输入 textField */
@property (weak, nonatomic) UITextField *oldPasswordView;
/** 新密码 输入 textField */
@property (weak, nonatomic) UITextField *novoPasswordView;
/** 验证新密码 输入 textField */
@property (weak, nonatomic) UITextField *checkPassworeView;
/** 提交按钮 */
@property (weak, nonatomic) UIButton    *submitButttonView;

@end

@implementation UserUpdatePasswordViewController


#pragma mark ----- 生命周期方法
/**
 *  页面加载完毕之后调用
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ----- 初始化UI

/**
 *  初始化 UI
 */
- (void) initUI {
    [self settingNav];
    [self backgroundView];
    [self oldPassword];
    [self novoPasswordView];
    [self checkPassworeView];
    [self submitButttonView];
}



/**
 *  设置导航栏
 */
- (void) settingNav {
    
    [self setHiddenTabbar:YES];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = Color(243, 243, 243, 255);
}

/**
 *  添加一个背景 view
 *
 *  @return UIView
 */
- (UIView *)backgroundView {
    
    if (_backgroundView == nil) {
        
        UIView *backgroundView = [[UIView alloc] init];
        CGFloat viewX = self.view.frame.origin.x + padding;
        CGFloat viewY = self.view.frame.origin.y + padding;
        CGFloat viewW = self.view.frame.size.width - padding * 2;
        CGFloat viewH = 121;
        backgroundView.frame = CGRectMake(viewX, viewY, viewW, viewH);
        backgroundView.backgroundColor       = Color(208, 208, 208, 255);
        backgroundView.layer.borderWidth     = 0.5;
        backgroundView.layer.cornerRadius    = 5 / 1;
        backgroundView.layer.masksToBounds   = YES;
        backgroundView.layer.borderColor     = Color(208, 208, 208, 255).CGColor;
        _backgroundView                      = backgroundView;
        [self.view addSubview:_backgroundView];
    }
    return _backgroundView;
}

/**
 *  添加一个 原密码输入框
 *
 *  @return UITextField
 */
- (UITextField *)oldPassword {
    
    if (_oldPasswordView == nil) {
        UITextField *oldPasswordView = [[UITextField alloc] init];
        CGFloat oldX = 0;
        CGFloat oldY = 0;
        CGFloat oldW = self.backgroundView.frame.size.width;
        CGFloat oldH = self.backgroundView.frame.size.height / 3;
        oldPasswordView.frame           = CGRectMake(oldX, oldY, oldW, oldH);
        oldPasswordView.backgroundColor = [UIColor whiteColor];

        oldPasswordView.leftViewMode    = UITextFieldViewModeAlways;
        oldPasswordView.font            = SYSTEM_FONT_SIZE(12);
        oldPasswordView.placeholder     = @"请输入原密码";
        oldPasswordView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [oldPasswordView setSecureTextEntry:YES];

        
        // 现在 textField 左侧显示 一张图
        UIImage     *image       = [UIImage imageNamed:@"login_password"];
        UIImageView *imageView   = [[UIImageView alloc] initWithImage:image];
        // 图片居中
        imageView.contentMode    = UIViewContentModeCenter;
        UIView  *view   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.frame = view.frame;
        [view addSubview:imageView];
        oldPasswordView.leftView = view;
        _oldPasswordView         = oldPasswordView;
        [self.backgroundView addSubview:_oldPasswordView];
    }
    return _oldPasswordView;
}

/**
 *  添加一个新密码输入框
 *
 *  @return UITextField
 */
- (UITextField *)novoPasswordView {
    
    if (_novoPasswordView == nil) {
        UITextField *novoPasswordView = [[UITextField alloc] init];
        CGFloat novoX = self.oldPasswordView.frame.origin.x;
        CGFloat novoY = CGRectGetMaxY(self.oldPasswordView.frame) + 0.5;
        CGFloat novoW = self.oldPasswordView.frame.size.width;
        CGFloat novoH = self.oldPasswordView.frame.size.height;
        novoPasswordView.frame = CGRectMake(novoX, novoY, novoW, novoH);
        novoPasswordView.backgroundColor = [UIColor whiteColor];

        novoPasswordView.leftViewMode    = UITextFieldViewModeAlways;
        novoPasswordView.font            = SYSTEM_FONT_SIZE(12);
        novoPasswordView.placeholder     = @"请输入新密码";
        novoPasswordView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [novoPasswordView setSecureTextEntry:YES];
        
        // 现在 textField 左侧显示 一张图
        UIImage     *image       = [UIImage imageNamed:@"login_password"];
        UIImageView *imageView   = [[UIImageView alloc] initWithImage:image];
        // 图片居中
        imageView.contentMode    = UIViewContentModeCenter;
        UIView  *view   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.frame = view.frame;
        [view addSubview:imageView];
        novoPasswordView.leftView = view;
        _novoPasswordView         = novoPasswordView;
        [self.backgroundView addSubview:_novoPasswordView];
    }
    return _novoPasswordView;
}

/**
 *  添加一个 验证新密码 输入框
 *
 *  @return UITextField
 */
- (UITextField *)checkPassworeView {
    
    if (_checkPassworeView == nil) {
        
        UITextField *checkPassworeView = [[UITextField alloc] init];
        CGFloat checkX = self.novoPasswordView.frame.origin.x;
        CGFloat checkY = CGRectGetMaxY(self.novoPasswordView.frame) + 0.5;
        CGFloat checkW = self.novoPasswordView.frame.size.width;
        CGFloat checkH = self.novoPasswordView.frame.size.height;
        checkPassworeView.frame = CGRectMake(checkX, checkY, checkW, checkH);
        checkPassworeView.backgroundColor = [UIColor whiteColor];
        
        checkPassworeView.leftViewMode    = UITextFieldViewModeAlways;
        checkPassworeView.font            = SYSTEM_FONT_SIZE(12);
        checkPassworeView.placeholder     = @"重新输入新密码";
        checkPassworeView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [checkPassworeView setSecureTextEntry:YES];     //  设置暗文
        
        // 现在 textField 左侧显示 一张图
        UIImage     *image       = [UIImage imageNamed:@"register_code"];
        UIImageView *imageView   = [[UIImageView alloc] initWithImage:image];
        // 图片居中
        imageView.contentMode    = UIViewContentModeCenter;
        UIView  *view   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.frame = view.frame;
        [view addSubview:imageView];
        checkPassworeView.leftView = view;
        _checkPassworeView         = checkPassworeView;
        [self.backgroundView addSubview:_checkPassworeView];
        
    }
    return _checkPassworeView;
}

/**
 *  添加一个 提交 按钮
 *
 *  @return UIButton
 */
- (UIButton *)submitButttonView {
    
    if (_submitButttonView == nil) {
        
        UIButton *submitButttonView = [[UIButton alloc] init];
        
        CGFloat subX = self.backgroundView.frame.origin.x;
        CGFloat subY = CGRectGetMaxY(self.backgroundView.frame) + padding * 2;
        CGFloat subW = self.novoPasswordView.frame.size.width;
        CGFloat subH = 40;
        submitButttonView.frame = CGRectMake(subX, subY, subW, subH);
        submitButttonView.backgroundColor     = Color(121, 191, 208, 255);
        submitButttonView.titleLabel.font     = SYSTEM_FONT_SIZE(15);
        submitButttonView.layer.cornerRadius  = 5 / 1;
        submitButttonView.layer.masksToBounds = YES;
    
        // 按钮点击文字
        [submitButttonView setTitle:@"确认修改" forState:UIControlStateNormal];
        [submitButttonView setTitle:@"确认修改" forState:UIControlStateHighlighted];
        
        // 选中的颜色
        [submitButttonView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitButttonView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
        [submitButttonView addTarget:self action:@selector(updatePassword) forControlEvents:UIControlEventTouchUpInside];
        _submitButttonView                    = submitButttonView;
        [self.view addSubview:_submitButttonView];
    }
    return _submitButttonView;
}


#pragma mark ---- 数据处理

/**
 *  修改密码
 */
- (void) updatePassword {
    
    
    // 收起键盘
    [self.view endEditing:YES];
    
    // 验证
    if (![self checkPassword]) {
        return;
    }

    UserModel    *user  = [UserModel shareInstance];
    NSString     *url   = connect_url(@"edit_pass");
    NSDictionary *dict  = @{
                            @"app_key"     : url,
                            @"session_key" : user.session_key,
                            @"u_id"        : user.u_id,
                            @"old_pass"    : self.oldPasswordView.text,
                            @"new_pass"    : self.novoPasswordView.text,
                            };
    
    // POST 接口
    [Base64Tool postSomethingToServe:url andParams:dict isBase64:YES CompletionBlock:^(id param) {
        if ([param[@"code"] isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常！"];
    }];

}


/**
 *  密码验证
 *
 *  @return BOOL
 */
- (BOOL) checkPassword  {
    
    if ([self trimString:self.oldPasswordView.text].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"原密码不能为空！"];
        return NO;
    }
    
    if ([self trimString:self.novoPasswordView.text].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"新密码不能为空！"];
        return NO;
    }
    
    if ([self trimString:self.checkPassworeView.text].length == 0) {
        [SVProgressHUD showErrorWithStatus:@"验证密码不能为空！"];
        return NO;
    }
    
    if (![self.oldPasswordView.text isEqualToString:userDefault(@"PASSWORD")]) {
        [SVProgressHUD showErrorWithStatus:@"原密码不正确"];
        return NO;
    }
    
    if (![self.novoPasswordView.text isEqualToString:self.checkPassworeView.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不相同"];
        return NO;
    }
    
    return YES;
}

/**
 *  截取 字符串 前后空格
 *  @param      param
 *  @return     NSString
 */
- (NSString *) trimString:(NSString *)param {
    return [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}





@end
