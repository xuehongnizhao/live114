//
//  groupSubmitTableViewCell.h
//  CardLeap
//
//  Created by mac on 15/1/27.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol groupButtonDelegate <NSObject>
-(void)buttonActionAddSub:(NSInteger)index;
@end

@interface groupSubmitTableViewCell : UITableViewCell
@property (strong,nonatomic)id<groupButtonDelegate> delegate;
-(void)configureCell:(NSDictionary*)dic row:(NSInteger)row;
@end
