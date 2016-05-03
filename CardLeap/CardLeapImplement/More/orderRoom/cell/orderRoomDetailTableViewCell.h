//
//  orderRoomDetailTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/14.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "orderRoomDetailInfo.h"
#import "orderRoomInfo.h"

@interface orderRoomDetailTableViewCell : UITableViewCell
-(void)confirgureCell:(orderRoomDetailInfo*)info section:(NSInteger)section row:(NSInteger)row;
-(void)confirgureDetailCell:(orderRoomInfo*)info section:(NSInteger)section row:(NSInteger)row;
@end
