//
//  TwoAddressCateController.h
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;

@interface TwoAddressCateController : BaseViewController


/** 同城信息分类 */
@property (strong, nonatomic) NSArray        *cityAddress;

/** 同城地区二级分类 */
@property (strong, nonatomic) NSArray        *addressTwoCate;

/** 提交数据模型 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;


@end
