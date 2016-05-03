//
//  orderRoomInfo.h
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderRoomInfo : NSObject
@property (strong,nonatomic)NSString *cate_name;
@property (strong,nonatomic)NSString *rev_num;
@property (strong,nonatomic)NSString *score;
@property (strong,nonatomic)NSString *shop_id;
@property (strong,nonatomic)NSString *shop_name;
@property (strong,nonatomic)NSString *shop_pic;
@property (strong,nonatomic)NSString *shop_address;
@property (strong,nonatomic)NSString *shop_tel;
@property (strong,nonatomic)NSString *shop_desc;
@property (strong,nonatomic)NSArray *pic_list;
@property (strong,nonatomic)NSString *pic_num;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *shop_lat;
@property (strong,nonatomic)NSString *shop_lng;
#pragma mark --- 11.27 增加订酒店web页的url
@property (nonatomic, strong) NSString * message_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
