//
//  CityAddressOneCate.h
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityAddressOneCate : NSObject


/** 同城 地区 一级分类 ID */
@property (copy,    nonatomic) NSString *area_id;

/** 同城 地区 一级分类 名称 */
@property (copy,    nonatomic) NSString *area_name;

/** 同城 地区 二级分类 */
@property (strong,  nonatomic) NSArray  *son;


+ (instancetype) cityAddressOneCateWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;

@end
