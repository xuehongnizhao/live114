//
//  myOrderCenterTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderCenterInfo.h"

@protocol reviewDelegate <NSObject>
-(void)reviewDelegateAction :(NSInteger)index;
-(void)customPayActionDelegate:(NSInteger)index;
@end

@interface myOrderCenterTableViewCell : UITableViewCell
@property(strong,nonatomic)id<reviewDelegate> delegate;
-(void)confirgureCell:(myOrderCenterInfo*)info row:(NSInteger)row;
@end
