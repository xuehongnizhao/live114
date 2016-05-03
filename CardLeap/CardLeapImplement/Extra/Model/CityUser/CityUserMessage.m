//
//  CityUserMessage.m
//  CardLeap
//
//  Created by songweiping on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "CityUserMessage.h"

@implementation CityUserMessage


+ (instancetype) cityUserMessageWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}
- (instancetype) initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
//        [dict setValuesForKeysWithDictionary:dict];
     
        /**

        @property (copy, nonatomic) NSString *m_id;
        @property (copy, nonatomic) NSString *message_name;
        @property (copy, nonatomic) NSString *m_desc;
        @property (copy, nonatomic) NSString *price;
        @property (copy, nonatomic) NSString *contact;
        @property (copy, nonatomic) NSString *tel;
        @property (copy, nonatomic) NSString *area_id;
        @property (copy, nonatomic) NSString *area_name;
        @property (copy, nonatomic) NSString *father_a_id;
        @property (copy, nonatomic) NSString *father_a_name;
        @property (copy, nonatomic) NSString *c_id;
        @property (copy, nonatomic) NSString *cate_name;
        @property (copy, nonatomic) NSString *father_id;
        @property (copy, nonatomic) NSString *father_name;
        @property (strong, nonatomic) NSArray *message_pic;
         */
        
        self.m_id           = dict[@"m_id"];
        self.message_name   = dict[@"message_name"];
        self.price          = dict[@"price"];
        self.m_desc         = dict[@"m_desc"];
        self.contact        = dict[@"contact"];
        self.tel            = dict[@"tel"];
        self.area_id        = dict[@"area_id"];
        self.area_name      = dict[@"area_name"];
        self.father_a_id    = dict[@"father_a_id"];
        self.father_a_name  = dict[@"father_a_name"];
        self.c_id           = dict[@"c_id"];
        self.cate_name      = dict[@"cate_name"];
        self.father_id      = dict[@"father_id"];
        self.father_name    = dict[@"father_name"];
        self.message_pic    = dict[@"message_pic"];

        
        
    }
    
    
    return self;
}

@end
