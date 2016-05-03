//
//  GroupCheckCodeViewController.h
//  CardLeap
//
//  Created by mac on 15/1/28.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "groupDetailInfo.h"

@interface GroupCheckCodeViewController : BaseViewController
@property (strong,nonatomic) groupDetailInfo *info;
@property (strong,nonatomic) NSArray *passArray;
@property (strong,nonatomic) NSString *identifier;
@property (strong,nonatomic) NSString *pass_code;
@property (strong,nonatomic) NSDictionary *messageDict;
@end
