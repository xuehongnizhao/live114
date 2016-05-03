//
//  orderSeatDetailViewController.h
//  CardLeap
//
//  Created by mac on 15/1/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderSeatInfo.h"

@interface orderSeatDetailViewController : BaseViewController
@property (strong,nonatomic)orderSeatInfo *info;
@property (strong,nonatomic)NSString *shop_id;
@end
