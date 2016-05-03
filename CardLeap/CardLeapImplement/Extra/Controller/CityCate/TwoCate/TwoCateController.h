//
//  TwoCateController.h
//  CardLeap
//
//  Created by songweiping on 15/1/6.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;
@interface TwoCateController : BaseViewController


/** 提交同城信息数据 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;

/** 二级分类数组 */
@property (strong, nonatomic) NSArray  *cateMessage;

/** 同城信息分类 */
@property (strong, nonatomic) NSArray  *cityAddress;

@end
