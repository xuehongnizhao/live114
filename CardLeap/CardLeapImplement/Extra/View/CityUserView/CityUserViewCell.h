//
//  CityUserViewCell.h
//  CardLeap
//
//  Created by songweiping on 15/1/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityUserFrame;

@interface CityUserViewCell : UITableViewCell

@property (strong, nonatomic) CityUserFrame *cityUserFrame;

+ (instancetype) cityUserCellWithTableView:(UITableView *)tableView;

@end
