//
//  mySpikeChekCodeViewController.h
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  代金券 - 二维码页面

#import <UIKit/UIKit.h>
#import "mySpikeInfo.h"

@interface mySpikeChekCodeViewController : BaseViewController
@property (strong,nonatomic) mySpikeInfo *info;
@property (strong, nonatomic) NSString *spike_code;
@end
