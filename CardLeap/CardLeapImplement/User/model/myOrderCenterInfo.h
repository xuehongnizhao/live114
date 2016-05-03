//
//  myOrderCenterInfo.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOrderCenterInfo : NSObject
@property (strong,nonatomic)NSString *order_id;//订单id
@property (strong,nonatomic)NSString *shop_pic;//商家图片
@property (strong,nonatomic)NSString *shop_name;//商家名称
@property (strong,nonatomic)NSString *total_price;//总价
@property (strong,nonatomic)NSString *confirm_status;//订单状态
@property (strong,nonatomic)NSString *score;
@property (strong,nonatomic)NSString *is_pay;//在线支付状态
@property (strong,nonatomic)NSString *takeout_url;
-(id)initWithDictionary:(NSDictionary*)dic;
@end
