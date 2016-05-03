//
//  GroupPaySuccessViewController.h
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupDetailInfo.h"

@interface GroupPaySuccessViewController : BaseViewController
@property (strong,nonatomic)NSDictionary *messageDict;
@property (strong,nonatomic)NSString *pass_code;
@property (strong,nonatomic)NSString *order_id;
@property (strong,nonatomic)NSArray *passArray;
@property (strong,nonatomic)groupDetailInfo *info;
@end
