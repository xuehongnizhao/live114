//
//  CityUpdateDescViewController.m
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUpdateDescViewController.h"

#import "CityUpdateViewController.h"

#import "CityAddMessage.h"

@interface CityUpdateDescViewController () <UITextViewDelegate>

// ---------------------- UI 控件 ----------------------
/** 显示用户数据的文字  */
@property (weak, nonatomic)     UITextView  *cityDescTextView;

/** 显示用户数据的文字长度 */
@property (weak, nonatomic)     UILabel     *textNumLabelView;


// ---------------------- 数据模型 ----------------------
/** 显示文字的长度 */
@property (assign, nonatomic)   NSInteger   num;

@end

@implementation CityUpdateDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ----> UI设置

/**
 *  设置 UI
 */
- (void) initUI {
    
    [self settingNav];
    
    [self cityDescTextView];
    
    [self textNumLabelView];
}

/**
 *  设置 navigation 设置
 */
- (void) settingNav {
    
    self.navigationItem.title = @"描述";
    self.view.backgroundColor = Color(243, 243, 243, 255);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(didFinish)];
    
}


/**
 *  添加TextView控件
 *
 *  @return UITextView
 */
- (UITextView *)cityDescTextView {
    
    if (_cityDescTextView == nil) {
        
        UITextView *cityDescTextView     = [[UITextView alloc] init];
        CGFloat descX = self.view.frame.origin.x;
        CGFloat descY = self.view.frame.origin.x;
        CGFloat descW = self.view.frame.size.width;
        CGFloat descH = 200;
        cityDescTextView.delegate = self;
        cityDescTextView.text     = self.cityAddMessage.cityDesc;
        cityDescTextView.frame = CGRectMake(descX, descY, descW, descH);
        _cityDescTextView      = cityDescTextView;
        [self.view addSubview:_cityDescTextView];
    }
    return _cityDescTextView;
}


/**
 *  添加Label
 *
 *  @return UILabel
 */
- (UILabel *)textNumLabelView {
    
    if (_textNumLabelView == nil) {
        UILabel *textNumLabelView = [[UILabel alloc] init];
        CGFloat padding = 10;
        CGFloat numW    = 100;
        CGFloat numH    = 30;
        CGFloat numX    = self.cityDescTextView.frame.size.width - numW - padding;
        CGFloat numY    = self.cityDescTextView.frame.size.height - numH - padding;
        textNumLabelView.frame = CGRectMake(numX, numY, numW, numH);
        textNumLabelView.backgroundColor = [UIColor whiteColor];
        textNumLabelView.text  = [NSString stringWithFormat:@"%i/200", self.num];
        
        textNumLabelView.textColor = Color(191, 191, 191, 255);
        textNumLabelView.textAlignment = NSTextAlignmentRight;
        _textNumLabelView = textNumLabelView;
        [self.cityDescTextView addSubview:_textNumLabelView];
    }
    
    return _textNumLabelView;
}


#pragma mark ---- 初始化数据

/**
 *  数据初始化
 */
- (void) initData {
    self.num  = self.cityDescTextView.text.length;
}


#pragma mark ---- 点击完成

/**
 *  点击 完成
 */
- (void) didFinish {
    
    NSString *desc = self.cityDescTextView.text;
    if ([self isCheckDescLength:desc]) {
        CityAddMessage *message = self.cityAddMessage;
        message.cityDesc        = desc;
        [self toJumoUpdateCity:message];
    }
}


/**
 *  验证输入 文字的长度
 *
 *  @param   string
 *
 *  @return  BOOL
 */
- (BOOL) isCheckDescLength:(NSString *)string {
    
    NSString *desc = string;
    if (desc.length > 200 || desc.length < 10) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"数据长度不正确" message:@"请输入10 - 200个字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    return YES;
}


/**
 *  点击跳转编辑页面
 *
 *  @param message
 */
- (void) toJumoUpdateCity:(CityAddMessage *)message {
    
    // 取出 所有的控制器
    NSArray *subView = self.navigationController.viewControllers;
    for (CityUpdateViewController *updateCity in subView) {
        if ([updateCity isKindOfClass:[CityUpdateViewController class]]) {
            updateCity.cityAddMessage       = message;
            [self.navigationController popToViewController:updateCity animated:YES];
            break;
        }
    }
    
}




#pragma mark ---- UITextView delegate

/**
 *  计算出 文字输入的 长度 并显示出来
 *
 *  @param textView
 *  @param range
 *  @param text
 *
 *  @return
 */
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    self.textNumLabelView.text = [NSString stringWithFormat:@"%i/200", textView.text.length];
    return YES;
}


@end
