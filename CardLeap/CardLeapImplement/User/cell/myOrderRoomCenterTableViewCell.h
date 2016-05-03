//
//  myOrderRoomCenterTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/20.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderRoomCenterInfo.h"

@protocol orderRoomActionDelegate <NSObject>
-(void)orderRoomAction:(NSInteger)row;
@end

@interface myOrderRoomCenterTableViewCell : UITableViewCell
@property (strong,nonatomic)id<orderRoomActionDelegate> delegate;
-(void)confirgureCell:(myOrderRoomCenterInfo*)info row:(NSInteger)row;
@end
