//
//  ShopDishConfirmViewController.h
//  CardLeap
//
//  Created by lin on 12/31/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖 - 确认美食

#import <UIKit/UIKit.h>

@interface ShopDishConfirmViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray *dishArray;
@property (strong, nonatomic) NSString *total_count;
@property (strong, nonatomic) NSString *total_price;
@property (strong, nonatomic) NSString *shop_id;
/** 配送费 */
@property (strong, nonatomic) NSString *ship_price;
@end
