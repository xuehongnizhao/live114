//
//  EvenMoreToWebViewController.h
//  CardLeap
//
//  Created by songweiping on 15/1/23.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  关于app，隐私权限，使用帮助，二维码分享 页面

#import "BaseViewController.h"

@class EvenMoreIsToJump;

@interface EvenMoreToWebViewController : BaseViewController

/** 判断跳转加载 webView 的url */
@property (strong, nonatomic) EvenMoreIsToJump *evenMoreJomp;

@end
