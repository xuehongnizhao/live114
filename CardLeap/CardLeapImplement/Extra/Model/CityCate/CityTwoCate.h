//
//  CityTwoCate.h
//  CardLeap
//
//  Created by songweiping on 14/12/26.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityTwoCate : NSObject

@property (copy, nonatomic) NSString *cat_id;
@property (copy, nonatomic) NSString *cat_name;

+ (instancetype) cityTwoCateWith:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;


@end
