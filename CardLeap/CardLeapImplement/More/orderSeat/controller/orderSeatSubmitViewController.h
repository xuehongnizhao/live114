//
//  orderSeatSubmitViewController.h
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GET_SECURITY_CODE @"user/ac_user/send_code"

@interface orderSeatSubmitViewController : BaseViewController
@property (strong,nonatomic)NSString *hintMessage;
@property (strong,nonatomic)NSString *shop_id;
@end
