//
//  CityUserMessage.h
//  CardLeap
//
//  Created by songweiping on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityUserMessage : NSObject


/** 主键ID */
@property (copy, nonatomic) NSString *m_id;

/** 标题 */
@property (copy, nonatomic) NSString *message_name;

/** 描述 */
@property (copy, nonatomic) NSString *m_desc;

/** 价格 */
@property (copy, nonatomic) NSString *price;

/** 联系人 */
@property (copy, nonatomic) NSString *contact;

/** 电话 */
@property (copy, nonatomic) NSString *tel;

/** 地区二级分类ID */
@property (copy, nonatomic) NSString *area_id;

/** 地区二级名称 */
@property (copy, nonatomic) NSString *area_name;

/** 地区一级分类ID */
@property (copy, nonatomic) NSString *father_a_id;

/** 地区一级分名称 */
@property (copy, nonatomic) NSString *father_a_name;

/** 分类二级分类ID */
@property (copy, nonatomic) NSString *c_id;

/** 分类二级分类名称 */
@property (copy, nonatomic) NSString *cate_name;

/** 分类二级ID */
@property (copy, nonatomic) NSString *father_id;

/** 分类一级名称 */
@property (copy, nonatomic) NSString *father_name;

/** 图片数组 */
@property (strong, nonatomic) NSArray *message_pic;

+ (instancetype) cityUserMessageWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;

@end
