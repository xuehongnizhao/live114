//
//  CityListFrame.h
//  CardLeap
//
//  Created by songweiping on 14/12/27.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CityList;

@interface CityListFrame : NSObject

/** 头像的Frame */
@property (assign, nonatomic, readonly) CGRect messagePicFrame;

/** 名称的Frame */
@property (assign, nonatomic, readonly) CGRect messageNameFrame;

/** 简介的Frame */
@property (assign, nonatomic, readonly) CGRect messageDescFrame;

/** 时间的Frame */
@property (assign, nonatomic, readonly) CGRect messageTimeFrame;

/** 价格的Frame */
@property (assign, nonatomic, readonly) CGRect messagePriceFrame;

/** 控件的模型数据 */
@property (strong, nonatomic) CityList *cityList;


@end
