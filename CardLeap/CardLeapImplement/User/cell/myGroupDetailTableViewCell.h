//
//  myGroupDetailTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/2/2.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myGroupInfo.h"

@protocol myGroupDetailCellDelegate <NSObject>
-(void)orderActionDelegate:(NSInteger)index;
@end

@interface myGroupDetailTableViewCell : UITableViewCell
@property (strong,nonatomic)id<myGroupDetailCellDelegate> delegate;
-(void)confirgureCell:(myGroupInfo*)info  section:(NSInteger)section row:(NSInteger)row;
@end
