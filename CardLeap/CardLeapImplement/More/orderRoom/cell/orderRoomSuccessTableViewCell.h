//
//  orderRoomSuccessTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderRoomSuccessInfo.h"

@interface orderRoomSuccessTableViewCell : UITableViewCell
-(void)confirgureCell:(orderRoomSuccessInfo*)info row:(NSInteger)row;
@end
