//
//  myGroupInfo.h
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class groupDetailInfo;

@interface myGroupInfo : NSObject
@property (strong,nonatomic) NSString *order_id;//订单id
@property (strong,nonatomic) NSString *group_pic;//团购显示图片
@property (strong,nonatomic) NSString *group_name;//团购名称
@property (strong,nonatomic) NSString *grab_price;//总价
@property (strong,nonatomic) NSString *grab_num;//团购数量
@property (strong,nonatomic) NSString *is_pay;//是否支付
@property (strong,nonatomic) NSString *group_brief;//团购描述
@property (strong,nonatomic) NSString *group_desc;//团购详细信息
@property (strong,nonatomic) NSString *group_pass;//团购码--
@property (strong,nonatomic) NSString *add_time;//购买时间
@property (strong,nonatomic) NSString *group_id;//团购订单id
@property (strong,nonatomic) NSString *pay_url;//支付url
@property (strong,nonatomic) NSString *status;//订单状态
@property (strong,nonatomic) NSString *shop_id;//商家id
@property (strong,nonatomic) NSString *score;//团购评分
@property (strong,nonatomic) NSString *group_endtime;//团购截至时间
@property (strong,nonatomic) NSArray *pass_array;//团购凭证数组  依据该数组生成二维码
@property (strong,nonatomic) NSString *group_url;//团购url
@property (strong,nonatomic) NSString *single_price;//单价
-(id)initWithDictionary:(NSDictionary*)dict;

-(id) initwithGroupDetailInfo:(groupDetailInfo *)info;
@end
