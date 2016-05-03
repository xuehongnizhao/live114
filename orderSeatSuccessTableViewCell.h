//
//  orderSeatSuccessTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderSeatSuccessInfo.h"
@interface orderSeatSuccessTableViewCell : UITableViewCell
-(void)configureCell:(orderSeatSuccessInfo*)info row:(NSInteger)row;
@end
