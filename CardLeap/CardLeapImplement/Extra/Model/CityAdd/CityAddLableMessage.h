//
//  CityAddLableMessage.h
//  CardLeap
//
//  Created by songweiping on 15/1/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityAddLableMessage : NSObject


/** 名称 */
@property (copy, nonatomic)   NSString *name;

@property (copy, nonatomic)   NSString *title;

/** 分类 */
@property (copy, nonatomic)   NSString *cate;



/** 是否显示价格图片 */
@property (assign, nonatomic) BOOL isDisplayPriceImageView;

/** 是否显示 "元" */
@property (assign, nonatomic) BOOL isDisplayPriceTextView;

/** 显示Lable 或 TextField */
@property (assign, nonatomic) BOOL isDisplayLable;

@end
