//
//  myOrderRoomCenterInfo.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOrderRoomCenterInfo : NSObject
@property (strong,nonatomic)NSString *goods_cate;//分类
@property (strong,nonatomic)NSString *goods_desc;//描述
@property (strong,nonatomic)NSString *begin_time;//开始时间
@property (strong,nonatomic)NSString *end_time;//结束时间
@property (strong,nonatomic)NSString *use_name;//使用人姓名
@property (strong,nonatomic)NSString *hotel_tel;//商家电话
@property (strong,nonatomic)NSString *shop_name;//商家姓名
@property (strong,nonatomic)NSString *shop_pic;//商家图片
@property (strong,nonatomic)NSString *hotel_num;//订房间数量
@property (strong,nonatomic)NSString *seat_status;//状态
@property (strong,nonatomic)NSString *shop_id;//商家id
@property (strong,nonatomic)NSString *hotel_id;//订单id
@property (strong,nonatomic)NSString *score;//评分
-(id)initWithDictionary:(NSDictionary*)dic;
@end
