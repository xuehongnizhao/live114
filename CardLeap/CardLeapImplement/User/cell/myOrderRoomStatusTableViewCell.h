//
//  myOrderRoomStatusTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOrderRoomCenterInfo.h"

@protocol myOrderRoomStatusDelegate <NSObject>
-(void)go2RoomReviewAction;
@end

@interface myOrderRoomStatusTableViewCell : UITableViewCell
@property (strong,nonatomic)id<myOrderRoomStatusDelegate> delegate;
-(void)confirgureCell :(myOrderRoomCenterInfo*)info row:(NSInteger)row section:(NSInteger)section;
@end
