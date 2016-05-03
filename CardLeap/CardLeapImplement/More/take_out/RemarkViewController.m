//
//  RemarkViewController.m
//  CardLeap
//
//  Created by lin on 1/5/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import "RemarkViewController.h"

@interface RemarkViewController ()<UITextViewDelegate,UIAlertViewDelegate>
{
    UILabel *placeLable;
}
@property (strong, nonatomic) UITextView *remark_T;
@property (strong, nonatomic) UIButton *finishButton;
@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UILabel *hintLable;
@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [_remark_T becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_remark_T resignFirstResponder];
}
#pragma mark ---- 备注信息

- (void) setNoteString:(NSString *)noteString
{
    _noteString = noteString;
}

#pragma mark---------set UI
-(void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
//
    [self.view addSubview:self.remark_T];
    _remark_T.layer.borderWidth = 1;
    _remark_T.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_remark_T autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_remark_T autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_remark_T autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_remark_T autoSetDimension:ALDimensionHeight toSize:150.0f];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    placeLable = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 6.0, 200, 16)] ;
    [_remark_T addSubview:placeLable];
    placeLable.text = @"请输入1-200个字";
    placeLable.font = [UIFont systemFontOfSize:14.0f];
    placeLable.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.hintLable];
    [_hintLable autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:5.0f];
    [_hintLable autoSetDimension:ALDimensionHeight toSize:15.0f];
    [_hintLable autoSetDimension:ALDimensionWidth toSize:60.0f];
    [_hintLable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_remark_T withOffset:5.0f];
    
    if (self.noteString == nil || [self.noteString isEqualToString:@""] == YES) {
        
    }else {
        placeLable.hidden = YES;
        _hintLable.text = [NSString stringWithFormat:@"%i/200",(int)self.noteString.length];
    }
}

#pragma mark---------get UI
-(UILabel *)hintLable
{
    if (!_hintLable) {
        _hintLable = [[UILabel alloc] initForAutoLayout];
        _hintLable.text = @"0/200";
        //_hintLable.layer.borderWidth = 1;
        _hintLable.font = [UIFont systemFontOfSize:11.0f];
        _hintLable.textAlignment = NSTextAlignmentRight;
    }
    return _hintLable;
}

-(UIButton *)finishButton
{
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initForAutoLayout];
    }
    return _finishButton;
}

-(UITextView *)remark_T
{
    if (!_remark_T) {
        _remark_T = [[UITextView alloc] initForAutoLayout];
        _remark_T.delegate = self;
        _remark_T.text     = self.noteString;
//        _remark_T.placeholder = @"请输入10-200个字";
        //
        //_remark_T.contentVerticalAlignment=UIControlContentVerticalAlignmentTop;
        _remark_T.font = [UIFont systemFontOfSize:14.0f];
    
    }
    return _remark_T;
}

-(UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [_rightButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [_rightButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark----------click action
-(void)finishAction :(UIButton*)btn
{
    [_remark_T resignFirstResponder];
    if (_remark_T.text.length > 0) {
        if (_remark_T.text.length > 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小助手" message:@"输入信息过长，无法保存" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"返回");
            [self.delegate finishActionDelegate:_remark_T.text];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小助手" message:@"您还什么都没说呢" delegate:self cancelButtonTitle:@"没什么想说的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark------textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        placeLable.hidden = YES;
    }else {
        placeLable.hidden = NO;
    }
    if (textView == _remark_T) {
        int count = _remark_T.text.length;
        if (count>200) {
            _hintLable.text = [NSString stringWithFormat:@"%d/200",count];
#warning 2015.12.30 提示文字不能用alertView展示，否则进行POP时会出现屏幕位移现象。如果一定要用alerView，需要首先移除键盘的第一响应者，再加一个0.5秒的延迟，之后在POP，机器卡可能需要更长时间的延迟。
            [_remark_T resignFirstResponder];
            [SVProgressHUD showErrorWithStatus:@"最多输入200个字符"];
        }else{
            _hintLable.text = [NSString stringWithFormat:@"%d/200",count];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_remark_T resignFirstResponder];
    if (buttonIndex  == 0) {
        [self.delegate finishActionDelegate:_remark_T.text];
        [self.navigationController popViewControllerAnimated:NO];
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
