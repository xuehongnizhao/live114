//
//  SpikeCodeViewController.h
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "couponInfo.h"

@interface SpikeCodeViewController : BaseViewController
@property (strong, nonatomic) couponInfo *info;
@property (strong, nonatomic) NSString *spike_code;
@end
