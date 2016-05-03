//
//  ShopDishTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/29/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "takeoutDishInfo.h"
@class ShopDishTableViewCell;

@protocol ActionDelegate <NSObject>

-(void)addAction :(takeoutDishInfo*)info dishCell:(ShopDishTableViewCell*)cell btn:(UIButton*)sender;
-(void)subAction :(takeoutDishInfo*)info dishCell:(ShopDishTableViewCell*)cell;

-(void)didselectImage:(NSInteger)indexpath;

@end

@interface ShopDishTableViewCell : UITableViewCell
@property (strong, nonatomic) id<ActionDelegate> delegate;
-(void)configureCell :(takeoutDishInfo*)info index:(NSInteger)row;
@end
