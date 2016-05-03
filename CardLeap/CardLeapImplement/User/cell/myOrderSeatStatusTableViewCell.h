//
//  myOrderSeatStatusTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderSeatCenterInfo.h"

@protocol myOrderSeatStatusDelegate <NSObject>
-(void)goReviewAction;
@end

@interface myOrderSeatStatusTableViewCell : UITableViewCell
@property (strong,nonatomic)id<myOrderSeatStatusDelegate> delegate;
-(void)confirgureCell :(myOrderSeatCenterInfo*)info row:(NSInteger)row section:(NSInteger)section;
@end
