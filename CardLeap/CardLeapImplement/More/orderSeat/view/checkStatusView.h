//
//  checkStatusView.h
//  CardLeap
//
//  Created by mac on 15/1/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol checkStatusDelegate <NSObject>

-(void)cancelAction;
-(void)deleteOrderSeat;
-(void)orderSuccessAction;
@end

@interface checkStatusView : UIView
@property (strong,nonatomic)id<checkStatusDelegate> delegate;
@property (strong,nonatomic)NSString *identifier;
@property (strong,nonatomic)NSString *seat_id;
-(void)setSeatId :(NSString*)seat_id;

@end
