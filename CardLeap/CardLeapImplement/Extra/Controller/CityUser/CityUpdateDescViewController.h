//
//  CityUpdateDescViewController.h
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityAddMessage;

@interface CityUpdateDescViewController : BaseViewController

/** 提交模型数据 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;

/** 同城信息分类 */
@property (strong, nonatomic) NSArray        *cityAddress;

@end
