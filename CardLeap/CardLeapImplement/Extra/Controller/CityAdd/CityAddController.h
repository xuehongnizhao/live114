//
//  CityAddController.h
//  CardLeap
//
//  Created by songweiping on 14/12/28.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "BaseViewController.h"
@class CityAddMessage;

@interface CityAddController : BaseViewController

/** 发布选分类的数组 */
@property (strong, nonatomic) NSArray  *cityCates;

/** 提交模型数据 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;

/** 同城信息分类 */
@property (strong, nonatomic) NSArray        *cityAddress;




@end
