//
//  CityTableViewCell.h
//  CardLeap
//
//  Created by songweiping on 14/12/22.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityList;
@class CityListFrame;
@interface CityTableViewCell : UITableViewCell

/** 数据模型 */
@property (strong, nonatomic) CityList      *cityList;

/** frame模型(包含数据模型) */
@property (strong, nonatomic) CityListFrame *cityListFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
