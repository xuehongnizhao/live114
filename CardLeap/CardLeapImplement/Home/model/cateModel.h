//
//  cateModel.h
//  CardLeap
//
//  Created by lin on 12/10/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//
//  114   ---->     如意专区 六大分类数据模型

#import <Foundation/Foundation.h>

@interface cateModel : NSObject
@property (strong, nonatomic) NSString *cat_img;
@property (strong, nonatomic) NSString *cat_name;
@property (strong, nonatomic) NSString *cat_id;
@property (strong, nonatomic) NSString *cat_subHead;
@property (strong, nonatomic) NSString *normalColor;
@property (strong, nonatomic) NSString *hightLightedColor;
@property (strong, nonatomic) NSString *layoutColor;
@property (strong, nonatomic) NSString *cate_type;
-(id)initWithDictionary :(NSDictionary*)dic;
@end
