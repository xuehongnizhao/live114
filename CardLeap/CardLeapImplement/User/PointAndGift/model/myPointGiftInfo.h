//
//  myPointGiftInfo.h
//  cityo2o
//
//  Created by mac on 15/4/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myPointGiftInfo : NSObject
@property (strong,nonatomic)NSString *message_url;//详情url
@property (strong,nonatomic)NSString *mall_id;//积分产品id
@property (strong,nonatomic)NSString *mall_name;//礼品名称
@property (strong,nonatomic)NSString *how_use;//简介
@property (strong,nonatomic)NSString *mall_integral;//需要消耗的积分
@property (strong,nonatomic)NSString *img;//图片
@property (strong,nonatomic)NSString *result;//是否可以兑换
@property (strong,nonatomic)NSString *color;//1可以兑换 2不可以兑换

-(id)initWithDictionary:(NSDictionary*)dic;
@end
