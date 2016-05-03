//
//  ShopDetailViewController.h
//  CardLeap
//
//  Created by lin on 12/22/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopListInfo.h"
@interface ShopDetailViewController : BaseViewController
@property (strong, nonatomic) ShopListInfo *info;
@property (strong, nonatomic) NSString *shop_id;
@property (strong, nonatomic) NSString *my_lat;
@property (strong, nonatomic) NSString *my_lng;
/** 商家详情的URL */
@property (nonatomic ,strong) NSString * message_url;
@end
