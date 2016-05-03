//
//  ShopTakeOutSearchViewController.h
//  CardLeap
//
//  Created by mac on 15/2/11.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SEARCH_TAKE_POST connect_url(@"takeout_list")
@interface ShopTakeOutSearchViewController : BaseViewController
@property(nonatomic,copy) NSString *u_lng;
@property(nonatomic,copy) NSString *u_lat;
@end
