//
//  orderSeatDetailTableViewCellByCC.h
//  cityo2o
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Sky. All rights reserved.
//
//  订座商家详情页面-增加web简介(陈晨修改)

#import <UIKit/UIKit.h>
#import "orderSeatDetailInfo.h"
#import "orderSeatInfo.h"

@protocol clickImageActionDelegate <NSObject>
-(void)clickDelegate:(NSInteger)index;
@end

@interface orderSeatDetailTableViewCellByCC : UITableViewCell
@property (strong,nonatomic)id<clickImageActionDelegate> delegate;
-(void)confirgureCell:(orderSeatDetailInfo*)info section:(NSInteger)section row:(NSInteger)row;
-(void)confirgureDetailCell:(orderSeatInfo*)info section:(NSInteger)section row:(NSInteger)row;
@end
