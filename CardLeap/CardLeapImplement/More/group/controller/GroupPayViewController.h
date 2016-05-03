//
//  GroupPayViewController.h
//  CardLeap
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupDetailInfo.h"

@interface GroupPayViewController : BaseViewController
@property (strong,nonatomic)groupDetailInfo *info;
@property (strong,nonatomic)NSDictionary *dict;
@property (strong,nonatomic)NSString *order_id;
@property (strong,nonatomic)NSArray *passArray;
@end
