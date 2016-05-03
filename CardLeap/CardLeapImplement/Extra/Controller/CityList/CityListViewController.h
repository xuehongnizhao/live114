//
//  CityListViewController.h
//  CardLeap
//
//  Created by songweiping on 14/12/22.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "BaseViewController.h"

@class CityCateSon;

@interface CityListViewController : BaseViewController
 

/** 同城二级分类 */
@property (strong, nonatomic)   NSArray     *cityTwoCate;

/** 同城一级分类ID */
@property (copy, nonatomic)     NSString    *c_id;

/** 同城一级分类名称 */
@property (copy, nonatomic)     NSString    *cat_name;

/** 同城 地区 */
@property (strong, nonatomic)   NSArray     *cityAddress;

/** 同城分类信息 */
@property (strong, nonatomic)   NSArray     *cityCateArray;
@end
