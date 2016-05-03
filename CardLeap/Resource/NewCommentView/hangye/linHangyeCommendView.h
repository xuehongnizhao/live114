//
//  linHangyeCommendView.h
//  cityo2o
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class linHangyeModel;
@protocol linHangyeCommendViewDelegate <NSObject>
-(void)linHangyeclikButtonToPushViewController:(linHangyeModel*)module;

@end

@interface linHangyeCommendView : UIView

@property(nonatomic,assign)id<linHangyeCommendViewDelegate> delegate;

+(instancetype)initViewWithXib;

-(void)setIndustryButtonViewWithModuleArray:(NSArray*) moduleArray;

@end
