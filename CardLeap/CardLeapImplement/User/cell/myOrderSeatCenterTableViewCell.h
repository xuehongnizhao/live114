//
//  myOrderSeatCenterTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderSeatCenterInfo.h"

@protocol buttonActionDelegate <NSObject>
-(void)goToReviewDelegate :(NSInteger)tag;
@end

@interface myOrderSeatCenterTableViewCell : UITableViewCell
@property (strong,nonatomic) id<buttonActionDelegate> delegate;
-(void)confirgureCell:(myOrderSeatCenterInfo*)info row:(NSInteger)row;
@end
