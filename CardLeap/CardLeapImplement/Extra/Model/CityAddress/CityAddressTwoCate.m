//
//  CityAddressTwoCate.m
//  CardLeap
//
//  Created by songweiping on 15/1/8.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityAddressTwoCate.h"

@implementation CityAddressTwoCate


+ (instancetype) cityAddressTwoCateWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.area_id   = dict[@"area_id"];
        self.area_name = dict[@"area_name"];
    }
    return self;
}

@end
