//
//  commodityDisplayModel.h
//  cityo2o
//
//  Created by mac on 15/9/18.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  商品展示
 */
@interface commodityDisplayModel : NSObject
/** 商品名称 */
@property (nonatomic, strong) NSString *index_name;
/** 商品图片（URL） */
@property (nonatomic, strong) NSString *index_pic;
/** 商品URL地址 */
@property (nonatomic, strong) NSString *i_url;
//没用 先空着
@property (strong,nonatomic)NSString *i_tel;
@property (strong,nonatomic)NSString *index_type;
@end
