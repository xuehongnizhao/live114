//
//  orderSeatDetailTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderSeatDetailInfo.h"
#import "orderSeatInfo.h"

@protocol clickImageActionDelegate <NSObject>
-(void)clickDelegate:(NSInteger)index;
@end
#pragma mark ---  11.30 修改web页计算高度的方法
@protocol orderSeatCellWebViewHeight <NSObject>
// 下载成功，返回web高度
-(void) webViewDidLoad:(CGFloat )height;
// 下载失败，返回错误信息
-(void) webViewFailLoadWithError:(NSError *)error;
@end

@interface orderSeatDetailTableViewCell : UITableViewCell
@property (strong,nonatomic)id<clickImageActionDelegate> delegate;
@property (nonatomic, strong) id<orderSeatCellWebViewHeight> webViewHeightDelegate;
-(void)confirgureCell:(orderSeatDetailInfo*)info section:(NSInteger)section row:(NSInteger)row;
-(void)confirgureDetailCell:(orderSeatInfo*)info section:(NSInteger)section row:(NSInteger)row;
@end
