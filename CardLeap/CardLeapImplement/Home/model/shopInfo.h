//
//  shopInfo.h
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopInfo : NSObject
@property (strong, nonatomic) NSString *area_name;
@property (strong, nonatomic) NSString *cat_name;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *shop_action;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *shop_pic;
@property (strong, nonatomic) NSString *shop_brief;
@property (strong, nonatomic) NSString *shop_lat;
@property (strong, nonatomic) NSString *shop_lng;
/** 增加商家详情 */
@property (nonatomic, strong) NSString * message_url;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
