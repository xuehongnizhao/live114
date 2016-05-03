//
//  orderSeatReviewViewController.h
//  CardLeap
//
//  Created by mac on 15/1/21.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refreshDelegate <NSObject>
-(void)refreshAction;
@end

@interface orderSeatReviewViewController : BaseViewController
@property (strong,nonatomic)id<refreshDelegate> delegate;
@property (strong,nonatomic)NSString *shop_id;
@property (strong,nonatomic)NSString *seat_id;
@end
