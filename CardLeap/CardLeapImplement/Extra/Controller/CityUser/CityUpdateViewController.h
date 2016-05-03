//
//  CityUpdateViewController.h
//  CardLeap
//
//  Created by songweiping on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;

@interface CityUpdateViewController : BaseViewController

@property (copy, nonatomic)     NSString       *m_id;

/** 发布选分类的数组 */
@property (strong, nonatomic)   NSArray        *cityCates;

/** 提交模型数据 */
@property (strong, nonatomic)   CityAddMessage *cityAddMessage;

/** 同城信息分类 */
@property (strong, nonatomic)   NSArray        *cityAddress;

@end
