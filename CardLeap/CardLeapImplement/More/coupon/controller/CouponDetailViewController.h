//
//  CouponDetailViewController.h
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "couponInfo.h"
#import "mySpikeInfo.h"

@interface CouponDetailViewController : BaseViewController
@property (strong, nonatomic) couponInfo *info;
@property (strong, nonatomic) mySpikeInfo *myInfo;
@property (strong, nonatomic) NSString *share_url;
@property (strong, nonatomic) NSString *message_url;
@end
