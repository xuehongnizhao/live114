//
//  shopTakeCateInfo.h
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopTakeCateInfo : NSObject
@property (strong, nonatomic) NSString *review_num;
@property (strong, nonatomic) NSString *shop_address;
@property (strong, nonatomic) NSString *shop_take_desc;
@property (strong, nonatomic) NSString *ship_price;
@property (strong, nonatomic) NSString *num;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *begin_price;
@property (strong, nonatomic) NSString *shop_pic;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSMutableArray  *cate;
@property (strong, nonatomic) NSString *accept_time;
@property (strong, nonatomic) NSString *shipping;
@property (strong, nonatomic) NSString *timely;
@property (strong, nonatomic) NSString *is_ship;
@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *share_url;
-(id)initWithDictionary :(NSDictionary*)dict;

@end
