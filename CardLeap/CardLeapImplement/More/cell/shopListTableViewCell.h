//
//  shopListTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListInfo.h"
@interface shopListTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *shop_pic;
@property (strong, nonatomic) UILabel *shop_name;
@property (strong, nonatomic) UIView *score;
@property (strong, nonatomic) UILabel *area_name;
@property (strong, nonatomic) UILabel *num_estimate;
@property (strong, nonatomic) UILabel *type;
@property (strong, nonatomic) UIImageView *group_pic;
@property (strong, nonatomic) UIImageView *take_pic;
@property (strong, nonatomic) UIImageView *oreder_pic;
@property (strong, nonatomic) UIImageView *activity_pic;
@property (strong, nonatomic) UIImageView *spike_pic;
@property (strong, nonatomic) UIImageView *vip_pic;
@property (strong, nonatomic) UIImageView *rezheng_pic;
-(void)configureCell :(ShopListInfo*)info;
@end
