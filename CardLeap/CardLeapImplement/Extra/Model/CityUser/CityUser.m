//
//  CityUser.m
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUser.h"

@implementation CityUser

+ (instancetype) cityUserWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        self.m_id         = dict[@"m_id"];
        self.message_name = dict[@"message_name"];
        self.message_url  = dict[@"message_url"];
        self.browse       = dict[@"browse"];
        self.add_time     = dict[@"add_time"];
        self.cate_name    = dict[@"cate_name"];
        
    }
    return self;
}

@end
