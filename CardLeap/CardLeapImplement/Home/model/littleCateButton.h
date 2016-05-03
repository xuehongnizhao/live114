//
//  littleCateButton.h
//  CardLeap
//
//  Created by lin on 12/11/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "littleCateModel.h"

@protocol littleCateDelegate <NSObject>
@optional
-(void)clickAction :(NSInteger)index;
@end

@interface littleCateButton : UIView
@property (strong, nonatomic) id<littleCateDelegate> delegate;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIButton *btn;
-(id)initWithFrame:(CGRect)frame;
-(void)setUI :(littleCateModel*)model;
@end
