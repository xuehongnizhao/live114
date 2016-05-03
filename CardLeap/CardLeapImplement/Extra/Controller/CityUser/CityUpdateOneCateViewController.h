//
//  CityUpdateOneCateViewController.h
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;

@interface CityUpdateOneCateViewController : BaseViewController

/** 同城信息分类 */
@property (strong, nonatomic)   NSArray        *cityAddress;

/** 提交数据模型 */
@property (strong, nonatomic)   CityAddMessage *cityAddMessage;

/** 分类信息数据 */
@property (strong, nonatomic)   NSArray        *cityCates;

@end
