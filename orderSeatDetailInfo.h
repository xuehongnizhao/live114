//
//  orderSeatDetailInfo.h
//  CardLeap
//
//  Created by mac on 15/1/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderSeatDetailInfo : NSObject
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
@property (strong,nonatomic)NSString *share_url;
@property (strong,nonatomic)NSString *message_url;
#pragma mark --- 12.1 增加商店经纬度
@property (nonatomic, strong) NSString *shop_lat;
@property (nonatomic, strong) NSString *shop_lng;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
