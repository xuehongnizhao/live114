//
//  CityInfo.m
//  CardLeap
//
//  Created by songweiping on 14/12/29.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo

+ (instancetype) cityInoftWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.contact     = dict[@"contact"];
        self.message_url = dict[@"message_url"];
        self.tel         = dict[@"tel"];
        self.city_pic    = dict[@"city_pic"];
    }
    return self;
}

@end
