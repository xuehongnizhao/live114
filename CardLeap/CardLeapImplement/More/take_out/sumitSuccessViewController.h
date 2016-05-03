//
//  sumitSuccessViewController.h
//  CardLeap
//
//  Created by lin on 1/5/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 订单提交成功

#import <UIKit/UIKit.h>

@interface sumitSuccessViewController : BaseViewController
@property (strong, nonatomic) NSString *order_id;
/** 订单详情URL */
@property (nonatomic, strong) NSString *takeout_url;
@end
