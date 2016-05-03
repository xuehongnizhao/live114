//
//  myOrderSeatStatusViewController.h
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderSeatCenterInfo.h"

@interface myOrderSeatStatusViewController : BaseViewController
@property (strong,nonatomic)NSString *order_seat_id;
@property (strong,nonatomic)myOrderSeatCenterInfo *info;
@end
