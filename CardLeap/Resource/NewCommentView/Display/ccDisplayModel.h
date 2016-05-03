//
//  ccDisplayModel.h
//  cityo2o
//
//  Created by mac on 15/9/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ccDisplayModel : NSObject

@property (strong,nonatomic)NSString *goods_pic;//商品图片
@property (strong,nonatomic)NSString *goods_name;//商品名称
@property (strong,nonatomic)NSString *url;//跳转URL
@property (strong,nonatomic)NSString *index_name;//占位，没用、不能删
@end
