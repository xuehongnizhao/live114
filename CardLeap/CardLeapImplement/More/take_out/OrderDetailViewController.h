//
//  OrderDetailViewController.h
//  CardLeap
//
//  Created by lin on 1/5/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 订单详情

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : BaseViewController
@property (strong, nonatomic) NSString *order_id;
@property (strong,nonatomic)  NSString *identifier;
@property (nonatomic, strong) NSString *takeout_url;
@end
