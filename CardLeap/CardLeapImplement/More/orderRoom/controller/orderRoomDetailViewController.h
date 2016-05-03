//
//  orderRoomDetailViewController.h
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderRoomInfo.h"

@interface orderRoomDetailViewController : BaseViewController
@property (strong,nonatomic)orderRoomInfo *info;
@property (strong,nonatomic)NSString *shop_id;
@end
