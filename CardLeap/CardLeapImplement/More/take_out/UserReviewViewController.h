//
//  UserReviewViewController.h
//  CardLeap
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  菜品评价

#import <UIKit/UIKit.h>
#import "reviewDishInfo.h"

@protocol finishDelegate <NSObject>
-(void)finishDelegateAction:(NSInteger)index;
@end

@interface UserReviewViewController : BaseViewController

@property (strong, nonatomic) id<finishDelegate> delegate;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) reviewDishInfo *info;
@property (strong, nonatomic) NSString *order_id;
@end
