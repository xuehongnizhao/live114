//
//  myOrderSeatCenterInfo.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOrderSeatCenterInfo : NSObject
@property (strong,nonatomic)NSString *use_name;//订座位用户姓名
@property (strong,nonatomic)NSString *seat_tel;//订座位验证电话
@property (strong,nonatomic)NSString *shop_name;//商家名称
@property (strong,nonatomic)NSString *shop_pic;//商家图片
@property (strong,nonatomic)NSString *seat_num;//订座位数量
@property (strong,nonatomic)NSString *ri;//订座位日期
@property (strong,nonatomic)NSString *fen;//订座位日期
@property (strong,nonatomic)NSString *confirm_status;//订单确认情况
@property (strong,nonatomic)NSString *shop_id;//商家id
@property (strong,nonatomic)NSString *score;//商家评分
@property (strong,nonatomic)NSString *seat_id;//订单的id
-(id)initWithDictionary:(NSDictionary*)dic;
@end
