//
//  OrderSeatSearchViewController.h
//  CardLeap
//
//  Created by mac on 15/2/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEARCH_SEAT_POST connect_url(@"seat_shop")

/**
 *  该类为搜索类 拥有记忆历史输入功能还搜索帖子功能
 */

@interface OrderSeatSearchViewController : BaseViewController
@property(nonatomic,copy) NSString *u_lng;
@property(nonatomic,copy) NSString *u_lat;
@end
