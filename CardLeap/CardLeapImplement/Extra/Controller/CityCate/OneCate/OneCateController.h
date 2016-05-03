//
//  OneCateController.h
//  CardLeap
//
//  Created by songweiping on 15/1/6.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;

@interface OneCateController : BaseViewController

/** 同城信息分类 */
@property (strong, nonatomic) NSArray        *cityAddress;

/** 提交数据模型 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;

@end
