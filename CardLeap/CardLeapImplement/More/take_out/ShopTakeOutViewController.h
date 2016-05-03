//
//  ShopTakeOutViewController.h
//  CardLeap
//
//  Created by lin on 12/26/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  外卖- 商家菜品列表

#import <UIKit/UIKit.h>
#import "shopTakeoutInfo.h"
@interface ShopTakeOutViewController : BaseViewController
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) shopTakeoutInfo *info;
@end
