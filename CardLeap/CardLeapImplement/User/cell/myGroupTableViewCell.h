//
//  myGroupTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myGroupInfo.h"

@protocol myGroupCellDelegate <NSObject>
-(void)myOperation :(NSInteger)index row:(NSInteger)row;
@end

@interface myGroupTableViewCell : UITableViewCell
@property (strong,nonatomic) id<myGroupCellDelegate> delegate;
-(void)configureCell:(myGroupInfo*)info row:(NSInteger)row;
@end
