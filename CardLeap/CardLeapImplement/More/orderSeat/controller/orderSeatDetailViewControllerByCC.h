//
//  orderSeatDetailViewControllerByCC.h
//  cityo2o
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Sky. All rights reserved.
//
//  订座商家详情页面-增加web简介(陈晨修改)

#import "BaseViewController.h"
#import "orderSeatInfo.h"

@interface orderSeatDetailViewControllerByCC : BaseViewController
@property (strong,nonatomic)orderSeatInfo *info;
@property (strong,nonatomic)NSString *shop_id;
@end
