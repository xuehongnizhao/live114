//
//  recordInfo.h
//  cityo2o
//
//  Created by mac on 15/4/15.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordInfo : NSObject
@property (strong,nonatomic)NSString *messge_url;//兑换详情
@property (strong,nonatomic)NSString *img;//图片
@property (strong,nonatomic)NSString *mall_name;//名称
@property (strong,nonatomic)NSString *order_id;//兑换码
@property (strong,nonatomic)NSString *num;//数量
@property (strong,nonatomic)NSString *is_use;//是否使用
-(id)initWithDictionary:(NSDictionary*)dic;
@end
