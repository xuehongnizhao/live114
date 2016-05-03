//
//  CityOneCate.h
//  CardLeap
//
//  Created by songweiping on 14/12/26.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityOneCate : NSObject

/** 分类ID    */
@property (copy, nonatomic)     NSString *cat_id;
/** 分类名称  */
@property (copy, nonatomic)     NSString *cat_name;
/** 分类图片  */
@property (copy, nonatomic)     NSString *cat_pic;

/** 二级分类  */
@property (strong, nonatomic)   NSArray  *son;

+ (instancetype) cityOneCateWithDict:(NSDictionary *)dict;
- (instancetype) initWithDict:(NSDictionary *)dict;


@end
