//
//  CityAddMessage.h
//  CardLeap
//
//  Created by songweiping on 15/1/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityAddMessage : NSObject


/** 标题 */
@property (copy, nonatomic) NSString *cityTitle;

/** 描述 */
@property (copy, nonatomic) NSString *cityDesc;

/** 价格 */
@property (copy, nonatomic) NSString *cityPrice;

/** 联系人 */
@property (copy, nonatomic) NSString *cityContact;

/** 电话 */
@property (copy, nonatomic) NSString *cityTel;

/** 一级分类ID  */
@property (copy, nonatomic) NSString *cityOneCateId;

/** 一级分类名称 */
@property (copy, nonatomic) NSString *cityOneCateName;

/** 二级分类 ID */
@property (copy, nonatomic) NSString *cityTwoCateId;

/** 二级分类名称 */
@property (copy, nonatomic) NSString *cityTwoCateName;

/** 地区一级分类ID */
@property (copy, nonatomic) NSString *cityOneCateAddressID;

/** 地区一级分类名称 */
@property (copy, nonatomic) NSString *cityOneCateAddressName;

/** 地区二级分类ID */
@property (copy, nonatomic) NSString *cityTwoCateAddressID;

/** 地区二级分类名称 */
@property (copy, nonatomic) NSString *cityTwoCateAddressName;


/** 数据提交时 用的分类ID */
@property (copy, nonatomic) NSString *c_id;

/** 数据提交时 用的地区ID */
@property (copy, nonatomic) NSString *a_id;

/** 用户ID */
@property (copy, nonatomic) NSString *u_id;

/** 用户 session_key */
@property (copy, nonatomic) NSString *session_key;



@end
