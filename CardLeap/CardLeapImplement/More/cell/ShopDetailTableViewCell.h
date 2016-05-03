//
//  ShopDetailTableViewCell.h
//  CardLeap
//
//  Created by lin on 12/23/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "shopDetailInfo.h"
#import "ShopListInfo.h"
@protocol shopPicDelegate <NSObject>

-(void)clickAction;

@end

@interface ShopDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) id<shopPicDelegate> delegate;
-(void)configureCell :(NSInteger)index sectino:(NSInteger)section info:(shopDetailInfo*)shopInfo;
-(void)configureCellForMin :(NSInteger)index sectino:(NSInteger)section info:(ShopListInfo*)shopInfo;
@end
