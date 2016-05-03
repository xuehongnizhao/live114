//
//  RviewDishListViewController.h
//  CardLeap
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 评价/待评价菜品

#import <UIKit/UIKit.h>

@interface RviewDishListViewController : BaseViewController
@property (strong, nonatomic) NSMutableArray *dishArray;
@property (strong, nonatomic) NSString *order_id;
@end
