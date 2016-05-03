//
//  IndustryZoneView.h
//  cityo2o
//
//  Created by mac on 15/9/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class linHangyeModel;
@protocol linHangyeCommendViewDelegate <NSObject>
-(void)linHangyeclikButtonToPushViewController:(linHangyeModel*)module;

@end

@interface IndustryZoneView : UIView
//数据模型数组
@property (nonatomic, strong) NSArray *moduleArray;
@property(nonatomic,assign)id<linHangyeCommendViewDelegate> delegate;
@end
