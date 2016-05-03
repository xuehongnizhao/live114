//
//  LocationListViewController.h
//  CardLeap
//
//  Created by lin on 1/6/15.
//  Copyright (c) 2015 Sky. All rights reserved.
//
//  外卖 - 定位页面

#import <UIKit/UIKit.h>
#import "locatinoInfo.h"

@protocol locationDelegate <NSObject>

-(void)locationCurrentPostion :(locatinoInfo*)info;

@end

@interface LocationListViewController : BaseViewController
@property (strong, nonatomic) id<locationDelegate> delegate;
@end
