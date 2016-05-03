//
//  CityUpdateTwoCateViewController.h
//  CardLeap
//
//  Created by songweiping on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "BaseViewController.h"


@class CityAddMessage;
@interface CityUpdateTwoCateViewController : BaseViewController


/** 提交同城信息数据 */
@property (strong, nonatomic) CityAddMessage *cityAddMessage;

/** 二级分类数组 */
@property (strong, nonatomic) NSArray  *cateMessage;

/** 同城信息分类 */
@property (strong, nonatomic) NSArray  *cityAddress;

@end
