//
//  mySpikeInfo.h
//  CardLeap
//
//  Created by lin on 1/8/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mySpikeInfo : NSObject
@property (strong, nonatomic) NSString *is_pay;//是否使用
@property (strong, nonatomic) NSString *is_result;//是否过期
@property (strong, nonatomic) NSString *spike_name;//优惠券名称
@property (strong, nonatomic) NSString *spike_pic;//优惠券图片
@property (strong, nonatomic) NSString *use_end_time;//截至时间
@property (strong, nonatomic) NSString *message_url;//详情加载url
@property (strong, nonatomic) NSString *spike_id;//优惠券id
@property (strong, nonatomic) NSString *is_delete;//是否删除
@property (strong, nonatomic) NSString *spike_code;//二维码
@property (strong, nonatomic) NSString *share_url;//分享优惠券
@property (strong, nonatomic) NSString *is_use;//判断当前能不能使用
-(id)initWithDictionary:(NSDictionary*)dic;
@end
