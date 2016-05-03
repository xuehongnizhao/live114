//
//  orderRoomSubmitViewController.h
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderRoomDetailInfo.h"
#import "roomInfo.h"

@interface orderRoomSubmitViewController : BaseViewController
@property (strong,nonatomic)orderRoomDetailInfo *info;
@property (strong,nonatomic)roomInfo *goods_info;
@end
