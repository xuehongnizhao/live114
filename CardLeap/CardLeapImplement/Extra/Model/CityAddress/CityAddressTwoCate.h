//
//  CityAddressTwoCate.h
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityAddressTwoCate : NSObject

/** 同城 地区二级分类 ID */
@property (copy, nonatomic) NSString *area_id;

/** 同城 地区二级分类 名称 */
@property (copy, nonatomic) NSString *area_name;

+ (instancetype) cityAddressTwoCateWithDict:(NSDictionary *)dict;

- (instancetype) initWithDict:(NSDictionary *)dict;

@end
