//
//  CommendView.h
//  LeDing
//
//  Created by Sky on 14/11/6.
//  Copyright (c) 2014年 xiaocao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrayPageControl.h"
/**
 *  首页推荐页面
 */
@class littleCateModel;
@protocol CommendViewDelegate <NSObject>
-(void)clikButtonToPushViewController:(littleCateModel*)module;
@end

@interface CommendView : UIView
@property (strong, nonatomic) NSArray *buttonArray;
@property(nonatomic,assign)id<CommendViewDelegate> delegate;
@property (strong, nonatomic) GrayPageControl *facePageControl;
@property (strong, nonatomic) UIScrollView *faceView;
-(void)setButtonView :(NSArray*)array;
@end
