//
//  CateButtonView.h
//  CardLeap
//
//  Created by lin on 12/24/14.
//  Copyright (c) 2014 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cateButtonDelegate <NSObject>

-(void)chooseCateID :(NSInteger)cateID;

@end

@interface CateButtonView : UIView
@property (strong, nonatomic) id<cateButtonDelegate> delegate;
-(CateButtonView*)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray tagArray:(NSArray*)tagArray index:(NSInteger)index;
-(void)setIndex:(NSInteger)index;
@end
