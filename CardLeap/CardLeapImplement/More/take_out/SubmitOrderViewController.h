//
//  SubmitOrderViewController.h
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖 - 提交订单（付款）

#import <UIKit/UIKit.h>

@interface SubmitOrderViewController : BaseViewController
@property (strong, nonatomic) NSArray *dishArray;//菜品
@property (strong, nonatomic) NSString *orderJson;//订单信息
@property (strong, nonatomic) NSString *shop_id;//商家id
@property (strong, nonatomic) NSString *totalPrice;//总价
@end
